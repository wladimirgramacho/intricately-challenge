class SearchDnsRecords
  class MissingPage < StandardError; end

  Result = Struct.new(:success?, :error_messages, :response)

  PAGE_LIMIT = 10

  def initialize(page: page, included_hostnames: [], excluded_hostnames: [])
    @page = page
    @included_hostnames = included_hostnames
    @excluded_hostnames = excluded_hostnames
  end

  def process
    raise MissingPage if @page.nil?

    dns_records = query_dns_records

    response = {
      total_records: dns_records.count,
      records: format_records(dns_records),
      related_hostnames: related_hostnames(dns_records)
    }
    Result.new(true, nil, response)

  rescue StandardError => e
    Result.new(false, e.message, nil)
  end

  private

  def query_dns_records
    if @included_hostnames.empty? && @excluded_hostnames.empty?
      DnsRecord.all.page(@page).per(PAGE_LIMIT)
    else
      query = DnsRecord.includes(:hostnames)
      query = query.where(hostnames: { address: @included_hostnames }) unless @included_hostnames.empty?

      unless @excluded_hostnames.empty?
        excluded_dns_records_ids = DnsRecord.includes(:hostnames).where(hostnames: { address: @excluded_hostnames })
        query = query.where.not(id: excluded_dns_records_ids)
      end
      query.page(@page).per(PAGE_LIMIT)
    end
  end

  def format_records(dns_records)
    dns_records.order(:id).map { |dns_record| { id: dns_record.id, ip: dns_record.ip } }
  end

  def related_hostnames(dns_records)
    hostnames = []

    dns_records = DnsRecord.where(id: dns_records.pluck(:id))
    addresses_in_dns_records = dns_records
                                .includes(:hostnames).pluck(:address)
                                .without(@included_hostnames + @excluded_hostnames)

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