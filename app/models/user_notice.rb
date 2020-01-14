class UserNotice < ApplicationRecord
  belongs_to :notice
  belongs_to :user
  accepts_nested_attributes_for :group_users
end
