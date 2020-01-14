class Threadtype < ApplicationRecord
  has_many :threadtype_groups
  has_many :groups, through: :threadtype_groups
  accepts_nested_attributes_for :threadtype_groups
end
