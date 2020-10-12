require 'rails_helper'

feature 'User can edit his answer', %{
  In order to correct mistakes
  As an author of answer
  I's like to able to edit my answer
} do 

  given!(:user) { create(:user) }
  given!(:user_1) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:google_url) { 'http://google.com' }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    scenario 'edits his answer' do
      sign_in user
      visit question_path(question)
      click_on 'Edit'
      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with attached files' do
      sign_in user
      visit question_path(question)
      click_on 'Edit'
      within '.answers' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his answer by attach link' do
      sign_in user
      visit question_path(question)
      click_on 'Edit'
      within '.answers' do
        click_on 'add link'
        within all('.nested-fields').first do
          fill_in 'Name', with: 'My google best'
          fill_in 'Url', with: google_url
        end
        click_on 'Save'
      end

        expect(page).to have_link 'My google best'
    end

    scenario 'author remove file from answer ', js: true do
      sign_in user
      visit question_path(question)
      click_on 'Edit'
      # fill_in 'Body', with: 'My answer'
      within '.answers' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb"]
        click_on 'Save'
        click_on 'Remove file'
      end
    
      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario 'not author remove file from answer ', js: true do
      sign_in user
      visit question_path(question)
      within('.answers') do
        click_on 'Edit'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb"]
        click_on 'Save'
      end
        click_on 'Log Out'
        click_on 'Log In'
        sign_in(user_1) 
        visit questions_path
        click_on question.body
      within('.answers') do
        expect(page).to_not have_link 'Remove file'
      end
    end

    scenario 'edits his answer with errors' do
      sign_in user
      visit question_path(question)
      click_on 'Edit'
      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's answer" do
      sign_in(user_1) 
      visit questions_path
      click_on question.body
      
      within('.answers') do 
        expect(page).to_not have_content "Edit"
      end
    end
  end
end
