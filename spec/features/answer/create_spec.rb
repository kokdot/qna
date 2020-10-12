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
    given(:google_url) { 'http://google.com' }
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

    scenario 'add answer for the question with attached links', js: true do
      fill_in 'Body', with: 'My answer'
      click_on 'add link'
      all('.nested-fields').each do |a|
        within a do
          fill_in 'Name', with: "My google best link number"
          fill_in 'Url', with: google_url
        end
      end
      click_on 'Add answer'

      within '.answers' do
        expect(page.all('a', text: 'My google best link number').count).to eq 3
      end
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
