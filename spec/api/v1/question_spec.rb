require 'rails_helper'

describe "Questions API", type: :request do
	let(:headers) { { "ACCEPT" => "application/json" } }
	
  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
		let(:method) { 'get' }
    
    it_behaves_like 'API Authorizable'

    context "authorized" do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 3) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }
			let(:answer) { answers.first }
			let(:answer_response) { question_response['answers'].first }

			before do
				do_request(method, api_path, params: { access_token: access_token.token }, 
				headers: headers)
			end
      
      it 'return 200 status' do
        expect(response).to  be_successful
      end

      it 'return list of questions' do
        expect(json['questions'].size).to eq 3
      end

      it 'return all public fields' do
        %w[title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to  eq question.send(attr).as_json
        end
			end


			it 'return list of answers' do
				expect(question_response['answers'].size).to eq 3
			end

			it 'contains user object' do
				expect(question_response['user']['id']).to  eq question.user.id
			end

			it 'contains short title' do
				expect(question_response['short_title']).to eq question.title.truncate(7)
			end

			it 'return all public fields' do
				%w[id body created_at updated_at].each do |attr|
					expect(answer_response[attr]).to  eq answer.send(attr).as_json
				end
			end
    end
	end

	describe 'GET /api/v1/question/question_id' do
		let(:question) { create(:question, :with_file, :with_links, :with_comments) }
		let(:api_path) { "/api/v1/questions/#{question.id}" }
		let(:resource_response) { json['question'] }
		let(:method) { 'get' }
		
		it_behaves_like 'API Authorizable'

		context "authorized" do
			let(:access_token) { create(:access_token) }
			let(:resource) { question }
			before { get api_path, params: { access_token: access_token.token }, headers: headers }
			
			it_behaves_like 'API Contentable'
		end
	end

	describe 'POST /api/v1/questions' do
		let(:api_path) { '/api/v1/questions' }
		let(:method) { 'post' }
		
		it_behaves_like 'API Authorizable'

		context "authorized" do
			let(:access_token) { create(:access_token) }
			let(:valid_params) { { title: 'title of question', body: 'body of question' } }
			let(:invalid_params) { { title: 'title of question', body: '' } }
			let(:model) { Question }
			let(:resource) { :question }

			before do
				do_request(method, api_path, params: { question: {body: 'question body', title: 'title of question'}, 
						access_token: access_token.token }, headers: headers)
			end

			it_behaves_like 'API Createable'
		end
	end

	describe 'PATCH /api/v1/questions/:id' do
		let(:user) { create(:user) }
		let(:question) { create(:question, user: user) }
		let(:api_path) { "/api/v1/questions/#{question.id}" }
		let(:method) { 'patch' }
		
		it_behaves_like 'API Authorizable'
		
		context "authorized" do
			let(:access_token) { create(:access_token, resource_owner_id: user.id) }
			let(:resource_response) { json['question'] }
			let(:valid_params) { { title: 'title changed', body: 'question body changed' } }
			let(:invalid_params) { { title: '', body: '' } }
			let(:resource) { :question }

			it_behaves_like 'API Updateable'
		end
	end

	describe 'DELETE /api/v1/questions/:id' do
		let(:user) {create(:user)}
		let!(:question) { create(:question, user: user) }
		let(:api_path) { "/api/v1/questions/#{question.id}" }
		let(:method) { 'delete' }
		
		it_behaves_like 'API Authorizable' do
		end

		context "authorized" do
			let(:access_token) { create(:access_token, resource_owner_id: user.id) }
			let(:model) { Question }

			it_behaves_like 'API Destroyable'
		end
	end
end
