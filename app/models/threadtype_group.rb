class ThreadtypeGroup < ApplicationRecord
  belongs_to :group, optional: true
  belongs_to :threadtype, optional: true

  has_many :reportthreadtypes, dependent: :destroy
end
