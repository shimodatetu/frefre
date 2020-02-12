class Group < ApplicationRecord
  has_many :posts
  belongs_to :user
  has_many :threadtype_groups
  has_many :threadtypes, through: :threadtype_groups
  accepts_nested_attributes_for :threadtype_groups
  has_many :hashtags
  has_many :groups
  after_create_commit { ThreadBroadcastJob.perform_later self }
end
