require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe "GET #create" do
    describe "authorised user" do
      before { login(user) }
      
      context 'with valid attributes' do
        it "save the comment in the database" do
          expect{ post :create, params: { comment: {body: 'Comment Text'}, resource:'Question', resource_id: question }, format: :js }.to change(Comment, :count).by(1)
        end
        
        it 'render to create view' do
          post :create, params: { comment: {body: 'Comment Text'}, resource:'Question', resource_id: question }, format: :js
          expect(response).to render_template :create
        end
      end
      
      context 'with invalid attributes' do
        it "do not save the comment in the database" do
          expect{ post :create, params: { comment: {body: ''}, resource:'Question', resource_id: question }, format: :js }.to_not change(Comment, :count)
        end
        
        it 'render to create view' do
          post :create, params: { comment: {body: ''}, resource:'Question', resource_id: question }, format: :js
          expect(response).to render_template :create
        end
      end
    end
    describe "unauthorised user" do

      it "do not save the comment in the database" do
        expect{ post :create, params: { comment: {body: 'Comment Text'}, resource:'Question', resource_id: question }, format: :js }.to_not change(Comment, :count)
      end
    end
  end
end
