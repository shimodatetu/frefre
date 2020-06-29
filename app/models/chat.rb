class Chat < ApplicationRecord
  belongs_to :notice, optional: true
  belongs_to :user, optional: true
  has_one_attached :pict
  has_one_attached :video
  after_create_commit { ChatBroadcastJob.perform_later self }
end
