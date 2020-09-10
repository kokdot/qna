require 'rails_helper'

feature 'Author can select the best answer', %{
  In order to comunicate with peopls
  As an aurhor of question
  I's like to able to select the best answer
} do
  
  given!(:user) { create(:user) }
  given!(:user_1) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create_list(:answer, 5, question: question) }
  given!(:answer_1) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do
    scenario 'selects the best answer' do
      sign_in user
      visit question_path(question)
      within(".answer-#{answer_1.id}") do
        click_on 'The Best'
      end

      within('.answer1') do
        expect(page).to have_content answer_1.body
      end
    end

    scenario 'tries to selects the best answer for not your question' do
      sign_in user_1
      visit question_path(question)

      expect(page).to_not have_content 'The Best'
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'tries to selects the best answer for not your question' do
      visit question_path(question)

      expect(page).to_not have_content 'The Best'
    end
  end
end