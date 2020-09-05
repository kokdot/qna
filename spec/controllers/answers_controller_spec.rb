require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) {create(:question, user: user)}
  let!(:answer) {create(:answer, question: question, user: user)}

  before { login(user) }
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save the answer in the database' do
        expect{ post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(Answer, :count).by(1)
      end

      it 'answer belongs to question' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js

        expect(assigns(:answer).user).to eq user
      end
      
      it 'answer belongs to user' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
        
        expect(assigns(:answer).question).to eq question
      end

      it 'redirect to show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end
    
    context 'with invalid attributes' do
      it 'does not save the answer in the database' do
        expect{ post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
      end
      it 'redirect to show view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Your answer' do
      before { login(user) }
      
      it 'deletes the answer' do
        expect{ delete :destroy, params: {id: answer} }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question show' do
        delete :destroy, params: {id: answer}

        expect(response).to redirect_to question
      end
    end

    context 'Not your answer' do
      let!(:user_1) { create(:user) }

      before { login(user_1) }

      it "does'nt delete the answer" do
        expect{ delete :destroy, params: {id: answer} }.to_not change(Answer, :count)
      end

      it 're-render show view' do
        delete :destroy, params: {id: answer}
        
        expect(response).to redirect_to question
      end
    end
  end
end