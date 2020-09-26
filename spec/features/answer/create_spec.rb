require 'rails_helper'

feature 'User can add answer for question', %q{
In order to get answer for a community
As an authenticated user
I'd like to be able to add answer for question
} do

  given!(:question) { create(:question) }
  
  describe 'Authenticated user' do
    given!(:user) { create(:user) }
    given!(:user_1) { create(:user) }
    background do
        sign_in(user) 
        visit questions_path
        click_on question.body
    end
    scenario 'add answer for the question', js: true do
      fill_in 'Body', with: 'My answer'
      click_on 'Add answer'

      expect(page).to have_content 'My answer'
    end

    scenario 'add answer for the question with attached files', js: true do
      fill_in 'Body', with: 'My answer'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Add answer'
    
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'add answer with error', js: true do
      click_on 'Add answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit questions_path
      click_on question.body
    end

    scenario 'add answer for the question' do
      fill_in 'Body', with: 'My answer'
      click_on 'Add answer'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end