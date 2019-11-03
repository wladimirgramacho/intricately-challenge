class SearchDnsRecords
  Result = Struct.new(:success?, :error_messages, :response)

  PAGE_LIMIT = 10

  def initialize(page: page)
    @page = page
  end

  def process
    dns_records = DnsRecord.all.page(@page).per(PAGE_LIMIT)

    response = {
      total_records: dns_records.count,
      records: dns_records
    }
    Result.new(true, nil, response)
  end
end