class CreateDnsRecord
  class RecordInvalid < StandardError; end

  Result = Struct.new(:success?, :error_messages, :model_id)

  def initialize(ip:, hostnames:)
    @ip = ip
    @hostnames = hostnames
  end

  def process
    dns_record = DnsRecord.create(ip: @ip)
    raise RecordInvalid unless dns_record.valid?

    @hostnames.each do |hostname|
      dns_record.hostnames << Hostname.create(address: hostname)
    end

    Result.new(true, nil, dns_record.id)
  rescue StandardError => e
    Result.new(false, e.message, nil)
  end
end