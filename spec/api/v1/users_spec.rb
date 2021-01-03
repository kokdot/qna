require 'rails_helper'

describe "Users API", type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }
  describe 'GET /api/v1/users' do
    let(:api_path) { '/api/v1/users' }
    
    it_behaves_like 'API Authorizable' do
      let(:method) { 'get' }
    end

    context "authorized" do
      let!(:users) { create_list(:user, 5) }
      let(:user) { users.first }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:users_response) { json['users'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }
      
      it 'return 200 status' do
        expect(response).to  be_successful
      end

      it 'return list of users' do
        p users_response
        expect(users_response.size).to eq 4
      end
    end
  end
end
