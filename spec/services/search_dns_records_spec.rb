require 'rails_helper'

describe SearchDnsRecords do
  subject { described_class }

  describe 'process' do
    context 'with valid params' do
      it 'returns successful result' do
        result = subject.new(page: 1).process
        expect(result.success?).to be_truthy
      end

      it 'returns count of dns_records' do
        2.times {create(:dns_record) }
        result = subject.new(page: 1).process
        expect(result.response[:total_records]).to eq 2
      end

      it 'returns count of dns_records by page' do
        20.times { create(:dns_record) }
        result = subject.new(page: 1).process
        expect(result.response[:total_records]).to eq 10
      end

      it 'returns an array of dns_records' do
        records = []
        records << create(:dns_record, ip: '1.1.1.1')
        records << create(:dns_record, ip: '2.2.2.2')
        result = subject.new(page: 1).process
        expect(result.response[:records]).to eq(records)
      end

      it 'returns related hostnames' do
        hostnames = []
        hostnames << create(:hostname, address: 'lorem.com')
        hostnames << create(:hostname, address: 'ipsum.com')
        2.times do
          dns_record = create(:dns_record)
          dns_record.hostnames << hostnames
        end
        related_hostnames = hostnames.map { |h| { hostname: h[:address], count: 2 } }

        result = subject.new(page: 1).process
        expect(result.response[:related_hostnames]).to eq(related_hostnames)
      end
    end
  end
end