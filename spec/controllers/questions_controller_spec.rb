require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  
  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }
    it 'populates an array of all questions' do

      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end


  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns a new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns a new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new Link to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'assigns a new reward to @question' do
      expect(assigns(:question).reward).to be_a_new(Reward)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
      
    end
    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end
  
  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      
      it 'save the question in the database' do
        expect{ post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'question belongs to user' do
        post :create, params: { question: attributes_for(:question), user: user }
        
        expect(assigns(:question).user).to eq user
      end
      
      it 'redirect to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end
    context 'with invalid attributes' do
      it 'does not save the question in the database' do
        expect{ post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-render to new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    context 'for author' do
      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, params: {id: question, question: attributes_for(:question) }, format: :js
          expect(assigns(:question)).to eq question
        end

        it 'change question attributes' do
          patch :update, params: {id: question, question: { title: 'new title', body: 'new body', user: user } }, format: :js
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'redirect to updated question' do
          patch :update, params: {id: question, question: attributes_for(:question) }, format: :js

          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: {id: question, question: attributes_for(:question, :invalid) }, format: :js }
        it 'does not change question' do
          question.reload

          expect(question.title).to eq 'MyString'
          expect(question.body).to eq 'MyText'
        end

        it 're-render edit view' do
          expect(response).to render_template :update
        end
      end
    end

    context 'for not author' do
      let!(:question_1) {create(:question)}

      it 'do not change question attributes' do
        patch :update, params: {id: question_1, question: { title: 'new title', body: 'new body' } }, format: :js
        question_1.reload

        expect(question_1.title).to_not eq 'new title'
        expect(question_1.body).to_not eq 'new body'
      end

      it 'redirect to updated question' do
        patch :update, params: {id: question, question: attributes_for(:question) }, format: :js

        expect(response).to redirect_to question
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Your question' do
      before { login(user) }
      
      let!(:question) {create(:question, user: user)}
      it 'deletes the question' do
        expect{ delete :destroy, params: {id: question}, format: :js }.to change(Question, :count).by(-1)
      end

      it 'redirect to index' do
        delete :destroy, params: {id: question}, format: :js
        expect(response).to redirect_to questions_path
      end
    end

    context 'Not your question' do
      before { login(user) }

      let!(:question) {create(:question)}
      it "does'nt delete the question" do
        expect{ delete :destroy, params: {id: question}, format: :js }.to_not change(Question, :count)
      end

      it 're-render show view' do
        delete :destroy, params: {id: question}, format: :js
        
        expect(response).to redirect_to question
      end
    end
  end
end
