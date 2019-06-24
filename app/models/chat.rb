class Chat < ApplicationRecord
  belongs_to :notice
  belongs_to :user
  after_create_commit { NoticeBroadcastJob.perform_later self }
end
