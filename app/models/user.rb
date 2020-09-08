class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable
  before_save { self.email = email.downcase }
  before_create :create_activation_digest
  attr_accessor :remember_token, :activation_token, :reset_token
  has_many :reportusers, dependent: :destroy

  has_many :reportgroups, dependent: :destroy
  has_many :reportthreadtypes, dependent: :destroy

  has_many :posts, dependent: :destroy
  has_many :groups, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :userinfos, dependent: :destroy
  has_many :news, dependent: :destroy

  has_many :user_threadtypes, dependent: :destroy
  has_many :threadtypes, through: :user_threadtypes, dependent: :destroy
  accepts_nested_attributes_for :user_threadtypes

  has_many :approvals, dependent: :destroy

  has_many :user_notices, dependent: :destroy
  has_many :notices, through: :user_notices, dependent: :destroy
  accepts_nested_attributes_for :user_notices

  has_secure_password validations: false
  validates :password, length: (6..32),on: :create, format: { with: /\A[a-z0-9]+\z/i }, unless: :uid?
  validates :password, length: {minimum: 6}, on: :update, allow_blank: true, unless: :uid?

  has_many :following_relationships, foreign_key: "follower_id", class_name: "Relationship", dependent: :destroy
  has_many :followings, through: :following_relationships, dependent: :destroy
  has_many :follower_relationships, foreign_key: "following_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :follower_relationships, dependent: :destroy


  has_many :joining_relations, foreign_key: "joiner_id", class_name: "Relation", dependent: :destroy
  has_many :joinings, through: :joining_relations, dependent: :destroy
  has_many :joiner_relations, foreign_key: "joining_id", class_name: "Relation", dependent: :destroy
  has_many :joiners, through: :joiner_relations, dependent: :destroy

  has_one_attached :avater

  def following?(other_user)
    following_relationships.find_by(following_id: other_user.id)
  end

  def follow!(other_user)
    following_relationships.create!(following_id: other_user.id)
  end

  def unfollow!(other_user)
    following_relationships.find_by(following_id: other_user.id).destroy
  end

  def following_id?(other_user_id)
    following_relationships.find_by(following_id: other_user_id)
  end

  def follow_id!(other_user_id)
    following_relationships.create!(following_id: other_user_id)
  end

  def unfollow_id!(other_user_id)
    following_relationships.find_by(following_id: other_user_id).destroy!
  end




  def joining?(other_user)
    joining_relations.find_by(joining_id: other_user.id)
  end

  def join!(other_user)
    joining_relations.create!(joining_id: other_user.id)
  end

  def unjoin!(other_user)
    joining_relations.find_by(joining_id: other_user.id).destroy
  end

  def joining_id?(other_user_id)
    joining_relations.find_by(joining_id: other_user_id)
  end

  def join_id!(other_user_id)
    joining_relations.create!(joining_id: other_user_id)
  end

  def unjoin_id!(other_user_id)
    joining_relations.find_by(joining_id: other_user_id).destroy!
  end

  def check_image
    if !['.jpg', '.png', '.gif'].include?(File.extname(name).downcase)
        errors.add(:image, "JPG, PNG, GIFのみアップロードできます。")
    elsif file.size > 1.megabyte
        errors.add(:image, "1MBまでアップロードできます")
    end
  end
  #mount_uploader :image, ImageUploader
  #after_update { ProfileBroadcastJob.perform_later self  }

  validates :name, presence: true,format: { with: /\A[a-z0-9]+\z/i }, length: {maximum: 32}, unless: :uid?

  VALID_email_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.oauth = true
      user.password = ""
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.admit = false
      return user
    end
  end

end
