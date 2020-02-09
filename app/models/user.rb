class User < ApplicationRecord
  before_save { self.email = email.downcase }
  before_create :create_activation_digest
  attr_accessor :remember_token, :activation_token, :reset_token
  has_many :reportusers
  has_many :posts
  has_many :groups
  has_many :chats
  has_many :userinfos
  has_many :news

  has_many :user_notices
  has_many :notices, through: :user_notices
  accepts_nested_attributes_for :user_notices

  has_secure_password validations: false
  validates :password, length: (6..32),on: :create, format: { with: /\A[a-z0-9]+\z/i }, unless: :uid?
  validates :password, length: {minimum: 6}, on: :update, allow_blank: true, unless: :uid?

  has_many :following_relationships, foreign_key: "follower_id", class_name: "Relationship", dependent: :destroy
  has_many :followings, through: :following_relationships
  has_many :follower_relationships, foreign_key: "following_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :follower_relationships

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

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
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
      user.photo = auth.info.image
      user.oauth = true
      user.password = ""
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.admit = false
      return user
    end
  end

  private

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

end
