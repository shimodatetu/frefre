class Notice < ApplicationRecord
  has_many :chats, dependent: :destroy
  has_many :user_notices, dependent: :destroy
  has_many :users, through: :user_notices, dependent: :destroy
  accepts_nested_attributes_for :user_notices
  after_create_commit { NoticeBroadcastJob.perform_later self }
end
