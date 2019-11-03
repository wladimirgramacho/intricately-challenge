require 'rails_helper'

describe DnsRecordsController, type: :controller do
  describe 'POST #create' do
    let(:params) {
      {
        "dns_records": {
          "ip": "1.1.1.1",
          "hostnames_attributes": [
            {
              "hostname": "lorem.com"
            }
          ]
        }
      }
    }

    it 'returns success with valid params' do
      post :create, params: params
      expect(response).to have_http_status(:success)
    end
  end
end