require 'rails_helper'

feature 'User can destroy your question', %q{
In order to get answer from a community
As an authenticated user
I'd like to be able to destroy your the question
} do

  given(:user) { create(:user) }
  given(:user_1) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  
  describe 'Authenticated user' do
    scenario 'destroy your question' do
      sign_in(user)
      visit questions_path
      click_on question.body

      within('.question') do 
        click_on 'Destroy'
      end
      
      expect(page).to have_content 'Your question successfully destroyed.'
      expect(page).to_not have_content question.body
      expect(page).to_not have_content question.title
    end
    
    scenario 'destroy not your question' do
      sign_in(user_1)
      visit questions_path
      click_on question.body

      within('.question') do 
        expect(page).to_not have_content "Destroy"
      end
    end
  end

  describe 'Unauthenticated user' do

    scenario 'destroy not your question' do
      visit questions_path
      click_on question.body

      within('.question') do 
        expect(page).to_not have_content "Destroy"
      end
    end

  end
end