require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

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

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to  receive(:call)
      User.find_for_oauth(auth)
    end
    
    
    
  end
end
