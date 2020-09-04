require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) {create(:question, user: user)}
  let!(:answer) {create(:answer, question: question, user: user)}

  before { login(user) }
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save the answer in the database' do
        expect{ post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(Answer, :count).by(1)
      end

      it 'answer belongs to question' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }

        expect(assigns(:answer).user).to eq user
      end
      
      it 'answer belongs to user' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        
        expect(assigns(:answer).question).to eq question
      end

      it 'redirect to show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question
      end
    end
    
    context 'with invalid attributes' do
      it 'does not save the answer in the database' do
        expect{ post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(Answer, :count)
      end
      it 'redirect to show view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  context 'Your answer' do
    describe 'DELETE #destroy' do
      before { login(user) }
      
      # let!(:question) {create(:question, user: user)}
      it 'deletes the answer' do
        expect{ delete :destroy, params: {id: answer} }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question show' do
        delete :destroy, params: {id: answer}
        expect(response).to redirect_to question
      end
    end
  end

  context 'Not your answer' do
    describe 'DELETE #destroy' do
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