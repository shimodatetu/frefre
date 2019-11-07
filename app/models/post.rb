class Post < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :reportposts
  after_create_commit { MessageBroadcastJob.perform_later self }
  #mount_uploader :image, ImageUploader
end
