class CreateDnsRecord
  Result = Struct.new(:success?, :error_messages, :model_id)

  def initialize(ip:, hostnames:)
    @ip = ip
    @hostnames = hostnames
  end

  def process
    dns_record = DnsRecord.create(ip: @ip)
    @hostnames.each { |hostname| Hostname.create(address: hostname) }

    Result.new(true, nil, dns_record.id)
  end
end