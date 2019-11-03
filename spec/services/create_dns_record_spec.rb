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

      it 'associates hostnames and dns_records' do
        result = subject.new(params).process
        expect(DnsRecord.find(result.model_id).hostnames.count).to eq 2
      end

      it 'returns failure if dns record is already exists' do
        create(:dns_record, ip: '1.1.1.1')
        result = subject.new(params).process
        expect(result.success?).to be_falsey
      end

      it 'associates but does not create hostname if already exists' do
        Hostname.create(address: 'lorem.com')
        result = subject.new(params).process
        expect(Hostname.count).to eq 2
        expect(DnsRecord.find(result.model_id).hostnames.count).to eq 2
      end
    end

    context 'with invalid params' do
      it 'returns failure if ip is not passed' do
        result = subject.new(ip: nil, hostnames: ['lorem.com']).process
        expect(result.success?).to be_falsey
      end
    end
  end
end