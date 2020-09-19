require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of :body }

  describe 'Answer best_assign' do
    # let(:user) { create(:user) }
    # let!(:question) {create(:question, user: user)}
    let!(:answer) { create(:answer) }#, question: question, user: user)}

    # before { login(user) }

    it 'assign the best for answer' do
      answer.best_assign
      expect(answer.best).to_not be_falsy
    end
  end
end
