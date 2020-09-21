require 'rails_helper'

feature 'User can edit his question', %{
  In order to correct mistakes
  As an aurhor of answer
  I's like to able to edit my question
} do 

  given!(:user) { create(:user) }
  given!(:user_1) { create(:user) }
  given!(:question) { create(:question, user: user) }
  # given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    within('.edit-question') do 
      expect(page).to_not have_content "Edit Question"
    end
  end

  describe 'Authenticated user', js: true do
    scenario 'edits his question' do
      sign_in user
      visit question_path(question)
      click_on 'Edit Question'
      within '.edit-question' do
        # save_and_open_page
        fill_in 'Edit your question', with: 'edited question'
        fill_in 'Edit your title', with: 'edited title'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question'
        expect(page).to have_content 'edited title'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors' do
      sign_in user
      visit question_path(question)
      click_on 'Edit Question'
      fill_in 'Edit your title', with: ''
      click_on 'Save'

      expect(page).to have_content question.body
      expect(page).to have_content "Title can't be blank"
    end

    scenario "tries to edit other user's question" do
      sign_in(user_1) 
      visit questions_path
      click_on question.body
      
      within('.edit-question') do 
        expect(page).to_not have_content "Edit Question"
      end
    end
  end
end