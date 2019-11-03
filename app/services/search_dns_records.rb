class SearchDnsRecords
  Result = Struct.new(:success?, :error_messages, :response)

  PAGE_LIMIT = 10

  def initialize(page: page, included_hostnames: nil)
    @page = page
    @included_hostnames = included_hostnames
  end

  def process
    dns_records = DnsRecord.all.page(@page).per(PAGE_LIMIT)

    response = {
      total_records: dns_records.count,
      records: format_records(dns_records),
      related_hostnames: related_hostnames(dns_records)
    }
    Result.new(true, nil, response)
  end

  private

  def format_records(dns_records)
    dns_records.map { |dns_record| { id: dns_record.id, ip: dns_record.ip } }
  end

  def related_hostnames(dns_records)
    hostnames = []
    addresses_in_dns_records =
      dns_records.includes(:hostnames).pluck(:address)
      .without(@included_hostnames)
    addresses = addresses_in_dns_records.uniq
    addresses.each do |address|
      hostnames << {
        hostname: address,
        count: addresses_in_dns_records.count(address)
      }
    end
    hostnames
  end
end