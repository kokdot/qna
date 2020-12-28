shared_examples_for 'API Createable' do

	it 'return 200 status' do
		expect(response).to  be_successful
	end

	it 'save the valid answer in the database' do
		expect do 
			do_request(method, api_path, params: { resource => valid_params,
				access_token: access_token.token }, headers: headers)
		end.to change(model, :count).by(1)
	end

	it 'saves with correct attributes' do
		do_request(method, api_path, params: { resource => valid_params, 
			access_token: access_token.token }, headers: headers)
			
		expect(assigns(resource).body).to eq valid_params[:body]
	end
	
	it 'do not save the invalid question in the database' do
		expect do 
			do_request(method, api_path, params: { resource => invalid_params,
				access_token: access_token.token }, headers: headers)
		end.to_not change(model, :count)
	end

	it 'returns 422 status' do
		do_request(method, api_path, params: { resource => invalid_params, access_token: access_token.token }, headers: headers)
		expect(response).to have_http_status(422)
	end
end