require 'rails_helper'
describe Ability do
  
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :email_get, User}
    it { should be_able_to :email_post, User}

    it { should_not be_able_to :manage, :all }
  end

  describe "for admin" do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end 
  
  describe "for user" do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create :question }
    let(:answer) { create :answer }
    let(:question_1) { create :question, user: user }
    let(:answer_1) { create :answer, user: user }
    
    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question_1, user:user }
    it { should_not be_able_to :update, question, user:user }

    it { should be_able_to :update, answer_1, user:user }
    it { should_not be_able_to :update, answer, user:user }

    it { should be_able_to :update, create(:comment, commentable: answer, user: user), user:user }
    it { should_not be_able_to :update, create(:comment, commentable: answer, user: other), user:user }

    it { should be_able_to :update, create(:comment, commentable: question, user: user), user:user }
    it { should_not be_able_to :update, create(:comment, commentable: question, user: other), user:user }
    it { should be_able_to :best, create(:answer, question: question_1) }
    it { should be_able_to :destroy, create(:link, linkable: question_1) }

    it { should be_able_to :votes_up, question }
    it { should be_able_to :votes_down, question }
    it { should be_able_to :destroy, ActiveStorage::Attachment, record: { user: user } }
  end
end
