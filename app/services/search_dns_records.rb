class SearchDnsRecords
  Result = Struct.new(:success?, :error_messages, :response)

  def initialize(page: page)
    @page = page
  end

  def process
    Result.new(true, nil, nil)
  end
end