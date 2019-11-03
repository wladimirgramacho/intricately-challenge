require 'resolv'

class DnsRecord < ApplicationRecord
  has_and_belongs_to_many :hostnames

  validates :ip, uniqueness: true, format: { with: Resolv::IPv4::Regex }
end
