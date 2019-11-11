class Post < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :reportposts

  has_one_attached :picture
  after_create_commit { MessageBroadcastJob.perform_later self }
  #mount_uploader :image, ImageUploader
end
