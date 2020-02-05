class News < ApplicationRecord
  has_one_attached :pict
  has_one_attached :video
  belongs_to :user
end
