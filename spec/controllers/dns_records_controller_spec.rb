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
      expect_any_instance_of(CreateDnsRecord).to receive(:process)
      post :create, params: params
    end
  end
end