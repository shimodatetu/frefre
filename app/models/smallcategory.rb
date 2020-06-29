class Smallcategory < ApplicationRecord
  belongs_to :bigcategory, optional: true
  has_many :secretcategories, dependent: :destroy
end
