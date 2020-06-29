class Userinfo < ApplicationRecord
  belongs_to :user, optional: true
end
