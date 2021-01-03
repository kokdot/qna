require 'rails_helper'

describe "Profiles API", type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

  describe "GET /api/v1/profiles/me" do
    let(:method) { 'get' }
    let(:api_path) { '/api/v1/profiles/me' }
    it_behaves_like 'API Authorizable'

    # context "unauthorized" do
    #   it 'return 401 status if there is no access_token' do
    #     get , headers: headers
    #     expect(response.status).to  eq 401
    #   end
    #   it 'return 401 status if access_token is invalid' do
    #     get '/api/v1/profiles/me', params: { access_token: '1234' }, headers: headers
    #     expect(response.status).to  eq 401
    #   end
    # end
    
    context "authorized" do
      let (:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }
      
      it 'return 200 status' do
        expect(response).to  be_successful
      end

      it 'return all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to  eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not  have_key(attr)
        end
      end
    end
  end
end

