require 'rails_helper'

describe CreateDnsRecord do
  subject { described_class }

  describe 'process' do
    context 'with valid params' do
      let(:params) {
        {
          ip: '1.1.1.1',
          hostnames: ['lorem.com', 'ipsum.com']
        }
      }
      it 'returns success' do
        result = subject.new(params).process
        expect(result.success?).to be_truthy
      end

      it 'creates a DnsRecord and returns the id' do
        result = subject.new(params).process
        expect(result.model_id).to_not be nil
        expect(DnsRecord.count).to eq 1
      end

      it 'creates Hostnames' do
        result = subject.new(params).process
        expect(Hostname.count).to eq 2
      end
    end
  end
end