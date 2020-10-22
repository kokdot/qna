require 'rails_helper'

RSpec.describe VotesController, type: :controller do

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:question_1) { create(:question, user: user) }

  before { login(user) } 

  describe "POST #votes_up" do
    it 'save the vote in the database' do
      expect{ post :votes_up, params: { type: 'question', id: question }, format: :json }.to change(Vote, :count).by(1)
    end

    it 'user cant vote for your question' do
      expect{ post :votes_up, params: { type: 'question', id: question_1 }, format: :json }.to_not change(Vote, :count)
    end

    it 'user cant vote twice for question' do
      post :votes_up, params: { type: 'question', id: question_1 }, format: :json
      expect{ post :votes_up, params: { type: 'question', id: question_1 }, format: :json }.to_not change(Vote, :count)
    end
  end

  describe "POST #votes_down" do
    it 'save the vote in the database' do
      expect{ post :votes_down, params: { type: 'question', id: question }, format: :json }.to change(Vote, :count).by(1)
    end

    it 'user cant vote for your question' do
      expect{ post :votes_down, params: { type: 'question', id: question_1 }, format: :json }.to_not change(Vote, :count)
    end

    it 'user cant vote twice for question' do
      post :votes_up, params: { type: 'question', id: question_1 }, format: :json
      expect{ post :votes_down, params: { type: 'question', id: question_1 }, format: :json }.to_not change(Vote, :count)
    end
  end

  describe "Post #votes_cancel" do
    let(:question) { create(:question) }
    let!(:vote) { create(:vote, user: user, votable: question) }

    it 'user can cancel your vote' do
      expect{ post :votes_cancel, params: {type: 'question', id: question }, format: :json }.to change(Vote, :count).by(-1)
    end

    it 'user can create vote after it destroy' do
      post :votes_cancel, params: {type: 'question', id: question }, format: :json
      expect{ post :votes_up, params: { type: 'question', id: question }, format: :json }.to change(Vote, :count).by(1)
    end
  end
end
