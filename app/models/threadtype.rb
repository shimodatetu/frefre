class Threadtype < ApplicationRecord
  has_many :groups
  has_many :posts
  has_many :user_threadtypes
  has_many :users, through: :user_threadtypes
  accepts_nested_attributes_for :user_threadtypes
  self.inheritance_column = :_type_disabled

  has_one_attached :pict
end
