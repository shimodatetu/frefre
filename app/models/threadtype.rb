class Threadtype < ApplicationRecord
  has_many :groups, dependent: :destroy
  has_many :posts, dependent: :destroy

  has_many :user_threadtypes, dependent: :destroy
  has_many :users, through: :user_threadtypes, dependent: :destroy
  accepts_nested_attributes_for :user_threadtypes

  has_many :approvals, dependent: :destroy

  self.inheritance_column = :_type_disabled

  has_one_attached :pict
end
