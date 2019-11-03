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
        create(:dns_record)
        create(:dns_record)
        result = subject.new(page: 1).process
        expect(result.response[:total_records]).to eq 2
      end
    end
  end
end