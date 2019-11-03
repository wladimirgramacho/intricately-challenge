require 'rails_helper'

describe DnsRecordsController, type: :controller do
  describe 'POST #create' do
    let(:params) {
      {
        "dns_record": {
          "ip": "1.1.1.1",
          "hostnames_attributes": [
            {
              "hostname": "lorem.com"
            }
          ]
        }
      }.as_json
    }

    it 'returns success with valid params' do
      post :create, params: params
      expect(response).to have_http_status(:success)
    end

    it 'calls CreateDnsRecord service with params' do
      service_result = OpenStruct.new(success?: true)
      expect_any_instance_of(CreateDnsRecord).to receive(:process).and_return(service_result)
      post :create, params: params
    end

    it 'returns bad_request if service failed' do
      DnsRecord.create(ip: '1.1.1.1')
      post :create, params: params
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'GET #index' do
    it 'returns success with valid params' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end