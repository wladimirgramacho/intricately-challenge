class DnsRecordsController < ApplicationController
  def create
    ip = create_params[:ip]
    addresses = create_params[:hostnames_attributes].map {|h| h[:hostname]}

    result = CreateDnsRecord.new(ip: ip, hostnames: addresses).process

    if result.success?
      render json: { id: result.model_id }
    else
      render json: { error: result.error_messages, status: 400 }, status: 400
    end
  end

  def index
    result = SearchDnsRecords.new(
      page: params[:page],
      included_hostnames: params[:included_hostnames],
      excluded_hostnames: params[:excluded_hostnames]
    ).process

    if result.success?
      render json: { id: result.response }
    else
      render json: { error: result.error_messages, status: 400 }, status: 400
    end
  end

  private

  def create_params
    params.require(:dns_record).permit(:ip, hostnames_attributes: [:hostname]).to_h
  end
end 