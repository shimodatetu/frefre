class Group < ApplicationRecord
  has_many :posts, dependent: :destroy
  belongs_to :user, optional: true

  belongs_to :threadtype, optional: true
  has_many :hashtags, dependent: :destroy
  has_many :groups, dependent: :destroy
  after_create_commit { ThreadBroadcastJob.perform_later self }
end
