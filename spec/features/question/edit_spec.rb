require 'rails_helper'

feature 'User can edit his question', %{
  In order to correct mistakes
  As an aurhor of answer
  I's like to able to edit my question
} do 

  given!(:user) { create(:user) }
  given!(:user_1) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:google_url) { 'http://google.com' }

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
        fill_in 'Edit your question', with: 'edited question'
        fill_in 'Edit your title', with: 'edited title'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question'
        expect(page).to have_content 'edited title'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question by attach files' do
      sign_in user
      visit question_path(question)
      click_on 'Edit Question'
      within '.edit-question' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'edits his question by attach link' do
      sign_in user
      visit question_path(question)
      click_on 'Edit Question'
      within '.edit-question' do
        click_on 'add link'
        within all('.nested-fields').first do
          fill_in 'Name', with: 'My google best'
          fill_in 'Url', with: google_url
        end
        click_on 'Save'
      end

        expect(page).to have_link 'My google best'
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