class Group < ApplicationRecord
  has_many :posts
  belongs_to :user

  belongs_to :threadtype
  has_many :hashtags
  has_many :groups
  after_create_commit { ThreadBroadcastJob.perform_later self }
end
