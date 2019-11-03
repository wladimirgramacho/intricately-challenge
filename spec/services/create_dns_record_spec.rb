require 'rails_helper'

describe CreateDnsRecord do
  describe 'process' do
    it 'returns success with valid params' do
      result = described_class.new(ip: '1.1.1.1', hostnames: ['lorem.com', 'ipsum.com']).process
      expect(result.success?).to be_truthy
    end
  end
end