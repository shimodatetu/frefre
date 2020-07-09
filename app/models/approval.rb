class Approval < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :threadtype, optional: true
end
