class Hashtag < ApplicationRecord
  belongs_to :group, optional: true
end
