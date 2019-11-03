class DnsRecordsController < ApplicationController
  def create
    ip = create_params[:ip]
    addresses = create_params[:hostnames_attributes].map {|h| h[:hostname]}

    CreateDnsRecord.new(ip: ip, hostnames: addresses).process
  end

  private

  def create_params
    params.require(:dns_record).permit(:ip, hostnames_attributes: [:hostname]).to_h
  end
end 