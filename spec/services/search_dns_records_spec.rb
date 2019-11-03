require 'rails_helper'

describe SearchDnsRecords do
  subject { described_class }

  def create_dns_records_with_hostnames
    hostnames = []
    hostnames << create(:hostname, address: 'lorem.com')
    hostnames << create(:hostname, address: 'ipsum.com')
    2.times do |n|
      dns_record = create(:dns_record, ip: "#{n}.#{n}.#{n}.#{n}")
      dns_record.hostnames << hostnames
    end
  end

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
        create(:dns_record, ip: '0.0.0.0')
        create(:dns_record, ip: '1.1.1.1')

        result = subject.new(page: 1).process
        expect(result.response[:records]).to eq([
          { id: 1, ip: '0.0.0.0' },
          { id: 2, ip: '1.1.1.1' }
        ])
      end

      it 'returns related hostnames' do
        create_dns_records_with_hostnames
        related_hostnames = [
          { hostname: 'ipsum.com', count: 2 }
        ]

        result = subject.new(page: 1, included_hostnames: ['lorem.com']).process
        expect(result.response[:related_hostnames]).to eq(related_hostnames)
      end

      describe 'optional arguments' do
        before do
          create_dns_records_with_hostnames
        end

        describe 'included hostnames' do
          it 'returns result only with included addresses' do
            result = subject.new(page: 1, included_hostnames: ['amet.com']).process
            expect(result.response).to eq({
              total_records: 0,
              records: [],
              related_hostnames: []
            })
          end

          it 'returns related_hostnames without included_hostnames' do
            result = subject.new(page: 1, included_hostnames: ['lorem.com']).process
            expect(result.response).to eq({
              total_records: 2,
              records: [
                { id: 1, ip: '0.0.0.0' },
                { id: 2, ip: '1.1.1.1' }
              ],
              related_hostnames: [
                { hostname: 'ipsum.com', count: 2 }
              ]
            })
          end
        end

        describe 'excluded hostnames' do
          it 'returns result only without excluded addresses' do
            result = subject.new(page: 1, excluded_hostnames: ['lorem.com']).process
            expect(result.response).to eq({
              total_records: 0,
              records: [],
              related_hostnames: []
            })
          end

          it 'returns related_hostnames without excluded_hostnames' do
            dns_record = create(:dns_record, ip: '2.2.2.2')
            dns_record.hostnames << create(:hostname, address: 'amet.com')
            result = subject.new(page: 1, excluded_hostnames: ['lorem.com']).process
            expect(result.response).to eq({
              total_records: 1,
              records: [
                { id: 3, ip: '2.2.2.2' }
              ],
              related_hostnames: [
                { hostname: 'amet.com', count: 1 }
              ]
            })
          end
        end
      end
    end

    context 'with invalid params' do
      it 'returns failure if page is not passed' do
        result = subject.new(page: nil).process
        expect(result.success?).to be_falsey
      end
    end
  end
end