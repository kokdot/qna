shared_examples_for 'API Destroyable' do
	it 'return 200 status' do
		do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
		expect(response).to  be_successful
	end

	it 'delete the resource in the database' do
		expect do
			do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
		end.to change(model, :count).by(-1)
	end

end