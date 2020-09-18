require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) {create(:question, user: user)}
  let!(:answer) {create(:answer, question: question, user: user)}

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'save the answer in the database' do
        expect{ post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(Answer, :count).by(1)
      end

      it 'answer belongs to user' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, user: user }, format: :js

        expect(assigns(:answer).user).to eq user
      end
      
      it 'answer belongs to question' do
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

  describe 'PATCH #update' do
    context 'for author' do
      before { login(user) }

      context 'with valid attributes' do
        it 'change answer attrubutes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload
          
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end

      end
      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js

          expect(response).to render_template :update
        end
      end
    end

    context 'for not author' do
      context 'authenticated user' do
        let(:user_1) { create(:user) }

        before { login(user_1) }

        it 'do not change answer attrubutes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload

          expect(answer.body).to_not eq 'new body'
        end

        it 'redirect to question' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js

          expect(response).to redirect_to question
        end
      end

      context 'unauthenticated user' do

        it 'do not change answer attrubutes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload

          expect(answer.body).to_not eq 'new body'
        end

        it 'redirect to question' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js

          expect(response).to have_http_status(401)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Your answer' do
      before { login(user) }
      
      it 'deletes the answer' do
        expect{ delete :destroy, params: {id: answer}, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question show' do
        delete :destroy, params: {id: answer}, format: :js

        expect(response).to redirect_to question
      end
    end

    context 'Not your answer' do
      let!(:user_1) { create(:user) }

      before { login(user_1) }

      it "does'nt delete the answer" do
        expect{ delete :destroy, params: {id: answer}, format: :js }.to_not change(Answer, :count)
      end

      it 're-render show view' do
        delete :destroy, params: {id: answer}, format: :js
        
        expect(response).to redirect_to question
      end
    end
  end

  describe 'POST #best' do
    let!(:answers) {create_list(:answer, 5)}

    it 'assigns the best to answer' do
      post :best , params: {id: answer}, format: :js
      answer.reload
      expect(answer.best).to_not be_falsey
    end
  end
end