require 'resolv'

class DnsRecord < ApplicationRecord
  validates :ip, uniqueness: true, format: { with: Resolv::IPv4::Regex }
end
