require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) {create(:question, user: user)}
  let!(:answer) {create(:answer, :with_file, question: question, user: user)}

  describe 'POST #delete' do
    before { login(user) }

    it 'assign file by id' do
      delete :destroy, params: {id: answer.files[0]}, format: :js

      expect(assigns(:file).filename.to_s).to eq 'rails_helper.rb'
    end

    it 'delete file' do
      expect do
        delete :destroy, params: {id: answer.files[0]}, format: :js
      end.to change(ActiveStorage::Attachment, :count).by(-1)
    end

    it 'render view delete' do
      delete :destroy, params: {id: answer.files[0]}, format: :js
      expect(response).to render_template :destroy
    end
  end
end
