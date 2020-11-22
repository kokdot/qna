require 'rails_helper'

feature 'User can see new question in realtime', %q{
  In order to get information immediatly
  I'd like to able to get realtime information
} do
  
  given(:user) {create(:user)}
  given(:user_1) {create(:user)}

  scenario "new question appears in another user's page", js: true do
    Capybara.using_session('user') do
      sign_in(user)
      visit questions_path
    end
    
    Capybara.using_session('user_1') do
      # sign_in(user_1)
      visit questions_path
    end

    Capybara.using_session('user') do
      click_on 'Ask question'
      
      fill_in 'Title', with: 'Title of question'
      fill_in 'Body', with: 'Body of question'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.' 
      expect(page).to have_content 'Title of question' 
      expect(page).to have_content 'Body of question' 
    end

    Capybara.using_session('user_1') do
      expect(page).to have_content 'Title of question' 
      expect(page).to have_content 'Body of question' 
    end
  end
end
