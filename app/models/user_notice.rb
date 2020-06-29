class UserNotice < ApplicationRecord
  belongs_to :notice, optional: true
  belongs_to :user, optional: true
end
