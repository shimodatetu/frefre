class Reportpost < ApplicationRecord
  belongs_to :post, optional: true
end
