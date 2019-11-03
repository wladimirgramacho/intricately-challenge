class Hostname < ApplicationRecord
  validates_uniqueness_of :address
end
