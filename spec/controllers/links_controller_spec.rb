require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) {create(:question, :with_link, user: user)}

  describe 'POST #delete' do
    before { login(user) }

    it 'assign link by id' do
      delete :destroy, params: {id: question.links.first}, format: :js

      expect(assigns(:link).name).to eq 'My google'
    end

    it 'delete link' do
      expect do
        delete :destroy, params: {id: question.links.first}, format: :js
      end.to change(Link, :count).by(-1)
    end

    it 'render view delete' do
      delete :destroy, params: {id: question.links.first}, format: :js
      expect(response).to render_template :destroy
    end
  end
end
