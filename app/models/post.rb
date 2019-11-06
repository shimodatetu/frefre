class Post < ApplicationRecord
  belongs_to :user
  belongs_to :group
  belongs_to :reportpost
  after_create_commit { MessageBroadcastJob.perform_later self }
  #mount_uploader :image, ImageUploader
end
