class User < ApplicationRecord
  before_create :create_activation_digest
  attr_accessor :remember_token, :activation_token, :reset_token
  has_many :posts
  has_many :groups
  has_many :chats
  has_and_belongs_to_many :notices
  has_secure_password
  validates :password, length: (6..32),on: :create, format: { with: /\A[a-z0-9]+\z/i }
  validates :password, length: {minimum: 6}, on: :update, allow_blank: true
  #mount_uploader :image, ImageUploader
  after_update { ProfileBroadcastJob.perform_later self  }

  validates :name, presence: true,format: { with: /\A[a-z0-9]+\z/i }
  validates :email, uniqueness:true,presence: true

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
  private

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

end
