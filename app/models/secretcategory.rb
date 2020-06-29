class Secretcategory < ApplicationRecord
  belongs_to :smallcategory, optional: true
end
