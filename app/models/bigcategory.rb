class Bigcategory < ApplicationRecord
  has_many :smallcategories, dependent: :destroy
end
