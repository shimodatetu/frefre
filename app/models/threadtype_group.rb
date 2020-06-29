class ThreadtypeGroup < ApplicationRecord
  belongs_to :group, optional: true
  belongs_to :threadtype, optional: true
end
