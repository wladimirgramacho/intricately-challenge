require 'rails_helper'

RSpec.describe DnsRecord, type: :model do
  it { should have_and_belong_to_many :hostnames }
  it { should validate_uniqueness_of(:ip) }

  it 'validates ip address format' do
    expect(DnsRecord.new(ip: '1.1.1.1')).to be_valid
    expect(DnsRecord.new(ip: '1.1.1.260')).to_not be_valid
  end
end
