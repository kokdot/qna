require 'rails_helper'

feature 'User can vote ', %q{
In order to express my opinion for community
As an authenticated user
I'd like to be able to vote
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:question_1) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }
  given!(:answer_1) { create(:answer, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  describe "question" do
    scenario 'User vote up' , js: true do
      within '.question_vote' do
        click_on 'vote_up'
        expect(page).to have_content '1'
      end
    end
    
    scenario 'User vote down' , js: true do
      within '.question_vote' do
        click_on 'vote_down'
        expect(page).to have_content '-1'
      end
    end
    
    scenario 'User can cancel your vote' , js: true do
      within '.question_vote' do
        click_on 'vote_up'
        click_on 'vote_cancel'
        expect(page).to have_content '0'
      end
    end
    
    scenario 'User cant twice vote' , js: true do
      within '.question_vote' do
        click_on 'vote_up'
        click_on 'vote_up'
        expect(page).to have_content 'You already vote or this is yours'
      end
    end
    
    scenario 'User can vote after cancel' , js: true do
      within '.question_vote' do
        click_on 'vote_up'
        click_on 'vote_cancel'
        click_on 'vote_up'
        expect(page).to have_content '1'
      end
    end
  end

  describe "answer" do
    scenario 'User vote up' , js: true do
      save_and_open_page
      within(".answer-#{answer.id}") do
        click_on 'vote_up'
        expect(page).to have_content '1'
      end
    end
    
    scenario 'User vote down' , js: true do
      within(".answer-#{answer.id}") do
        click_on 'vote_down'
        expect(page).to have_content '-1'
      end
    end
    
    scenario 'User can cancel your vote' , js: true do
      within(".answer-#{answer.id}") do
        click_on 'vote_up'
        click_on 'vote_cancel'
        expect(page).to have_content '0'
      end
    end
    
    scenario 'User cant twice vote' , js: true do
      within(".answer-#{answer.id}") do
        click_on 'vote_up'
        click_on 'vote_up'
        expect(page).to have_content 'You already vote or this is yours'
      end
    end
    
    scenario 'User can vote after cancel' , js: true do
      within(".answer-#{answer.id}") do
        click_on 'vote_up'
        click_on 'vote_cancel'
        click_on 'vote_up'
        expect(page).to have_content '1'
      end
    end
  end

  describe "Yours" do
    background do
      visit question_path(question_1)
    end
    scenario 'User cant vote your question' , js: true do
      within '.question_vote' do
        click_on 'vote_up'
        expect(page).to have_content 'You already vote or this is yours'
      end
    end

    scenario 'User cant vote your answer' , js: true do
      within(".answer-#{answer_1.id}") do
        click_on 'vote_up'
        expect(page).to have_content 'You already vote or this is yours'
      end
    end
  end
  
end
