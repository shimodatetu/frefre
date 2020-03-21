class Chat < ApplicationRecord
  belongs_to :notice
  belongs_to :user
  has_one_attached :pict
  has_one_attached :video
  after_create_commit { ChatBroadcastJob.perform_later self }
end
