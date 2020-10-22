require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }

  describe 'User author_of?' do
    let(:user) {create(:user) }
    let(:user_1) {create(:user) }
    let(:question) { create(:question, user:user) }

    it 'return true if user is author of qestion' do
      expect(user).to be_author_of(question)
    end

    it 'return false if user is not author of qestion' do
      expect(user_1).to_not be_author_of(question)
    end
  end
end
