shared_examples_for 'API Updateable' do
  context 'valid attributes' do

    before do
      do_request(method, api_path, params: { resource => valid_params, 
        access_token: access_token.token }, headers: headers) 
    end

    it 'save the resource in the database' do
      expect(resource_response[:body]).to eq valid_params['body']
    end

    it 'return 200 status' do
      expect(response).to  be_successful
    end

  end

  context 'invalid attributes' do
    
    before do
      do_request(method, api_path, params: { resource => invalid_params,
        access_token: access_token.token }, headers: headers)
    end

    it 'do not save the attr in the database' do
      expect(assigns(resource).reload.body).to  eq 'MyText'
    end

    it 'return 422 status' do
      expect(response).to have_http_status(422)
    end
  end
end
