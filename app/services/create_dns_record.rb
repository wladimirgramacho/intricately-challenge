class CreateDnsRecord
  Result = Struct.new(:success?, :error_messages, :model_id)

  def initialize(ip:, hostnames:)
    @ip = ip
    @hostnames = hostnames
  end

  def process
    Result.new(true, nil, nil)    
  end
end