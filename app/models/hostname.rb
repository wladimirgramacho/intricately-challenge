class Hostname < ApplicationRecord
  has_and_belongs_to_many :dns_records

  validates_uniqueness_of :address
end
