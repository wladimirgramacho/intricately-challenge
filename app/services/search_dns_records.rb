class SearchDnsRecords
  Result = Struct.new(:success?, :error_messages, :response)

  def initialize(page: page)
    @page = page
  end

  def process
    dns_records = DnsRecord.all

    response = {
      total_records: dns_records.count
    }
    Result.new(true, nil, response)
  end
end