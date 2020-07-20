class Reportthreadtype < ApplicationRecord
  belongs_to :threadtype, optional: true
  belongs_to :user, optional: true
end
