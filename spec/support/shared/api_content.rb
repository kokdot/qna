shared_examples_for 'API Contentable' do
  describe 'resouce' do

    it 'return 200 status' do
      expect(response).to  be_successful
    end

    it 'return list of links' do
      expect(resource_response['links'].size).to eq 3
    end
    
    it 'return list of comments' do
      expect(resource_response['comments'].size).to eq 3
    end
    
    it 'return list of files' do
      # p '*'*50
      # p answer_response['files']
      expect(resource_response['files'].size).to eq 2
    end

    it 'contains comments object' do
      expect(resource_response['comments'].first['id']).to eq(resource.comments.last.id)
    end

    it 'contains links object' do
      expect(resource_response['links'].first['id']).to eq(resource.links.last.id)
    end

    it 'contains files object' do
      expect(resource_response['files'].first['id']).to eq(resource.files.first.id)
    end

    it 'contains files url' do
      expect(resource_response['files'].first['url']).to eq rails_blob_path(resource.files.first, only_path: true)
    end
  end
end