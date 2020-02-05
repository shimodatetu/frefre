class Notice < ApplicationRecord
  has_many :chats
  has_many :user_notices
  has_many :users, through: :user_notices
  accepts_nested_attributes_for :user_notices
  after_create_commit { NoticeBroadcastJob.perform_later self }
end
