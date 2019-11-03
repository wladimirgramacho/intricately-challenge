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
      records: dns_records,
      related_hostnames: related_hostnames(dns_records)
    }
    Result.new(true, nil, response)
  end

  private

  def related_hostnames(dns_records)
    hostnames = []
    addresses_in_dns_records = dns_records.includes(:hostnames).pluck(:address)
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