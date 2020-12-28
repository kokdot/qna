require 'rails_helper'

describe "Anwers API", type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }
  
  describe 'GET /api/v1/questions/question_id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { 'get' }

    it_behaves_like 'API Authorizable'

    context "authorized" do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:answer) { answers.first }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:answer_response) { json['answers'].first }

      before do
        do_request(method, api_path, params: { access_token: access_token.token }, 
        headers: headers)
      end

      it 'return 200 status' do
        expect(response).to  be_successful
      end

      it 'return list of answers' do
        expect(json['answers'].size).to eq 3
      end

      it 'return all public fields' do
        %w[body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to  eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/answer_id' do
    let(:answer) { create(:answer, :with_file, :with_links, :with_comments) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:resource_response) { json['answer'] }
    let(:method) { 'get' }
    
    it_behaves_like 'API Authorizable'
    
    context "authorized" do
      let(:access_token) { create(:access_token) }
      let(:resource) { answer }
      # let(:resource_response) { json['answer'] }
      before do
        do_request(method, api_path, params: { access_token: access_token.token }, 
          headers: headers)
      end
      
      
      
      it_behaves_like 'API Contentable'
    end
  end


  describe 'POST /api/v1/questions/question_id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { 'post' }
    
    it_behaves_like 'API Authorizable' do
    end

    context "authorized" do
      let(:access_token) { create(:access_token) }
      let(:valid_params) { { body: 'answer body' } }
      let(:invalid_params) { { body: '' } }
      let(:model) { Answer }
      let(:resource) { :answer }
      let(:method) { 'post' }

      before do
        do_request(method, api_path, params: { question_id: question, answer: valid_params, 
            access_token: access_token.token }, headers: headers)
      end
      
      it_behaves_like 'API Createable'
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer, :special, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { 'patch' }
    let(:answer_response) { json['answer'] }
    
    it_behaves_like 'API Authorizable'

    context "authorized" do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:resource_response) { json['answer'] }
      let(:valid_params) { { body: 'answer body changed' } }
      let(:invalid_params) { { body: '' } }
      let(:resource) { :answer }

      it_behaves_like 'API Updateable'
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    context 'unauthorized' do
      let(:user) {create(:user)}
      let!(:answer) { create(:answer, user: user) }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { 'delete' }
      
      it_behaves_like 'API Authorizable'
    end
    
    context "authorized" do
      let(:user) {create(:user)}
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:answer) { create(:answer, user_id: user.id) }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:model) { Answer }
      let(:method) { 'delete' }
      
      it_behaves_like 'API Destroyable'
    end
  end
end
