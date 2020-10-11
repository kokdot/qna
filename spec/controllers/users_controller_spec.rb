require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #show" do
    let(:user) {create(:user) }
    let(:user_1) {create(:user) }
    let(:question) { create(:question, :with_reward, user: user) }
    let(:answer) { create(:answer, question: question, user: user_1) }
    before do
      login(user_1)
      answer.best_assign
      get :show
    end
    
    it 'return rewards of user' do
      expect(assigns(:rewards).first.name).to eq 'MyReward'
    end

    it 'render view show' do
      expect(response).to render_template :show
    end
  end
end
