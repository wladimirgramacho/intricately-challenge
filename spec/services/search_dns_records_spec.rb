require 'rails_helper'

describe SearchDnsRecords do
  subject { described_class }

  describe 'process' do
    context 'with valid params' do
      it 'returns dns_records by page' do
        result = subject.new(page: 1).process
        expect(result.success?).to be_truthy
      end
    end
  end
end