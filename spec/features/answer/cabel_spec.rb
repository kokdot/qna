require 'rails_helper'

feature 'User can see new answer in realtime', %q{
  In order to get information immediatly
  I'd like to able to get realtime information
} do
  
  given(:user) {create(:user)}
  given(:user_1) {create(:user)}
  given(:question) {create(:question)}

  scenario "new answer appears in another user's page", js: true do
    Capybara.using_session('user') do
      sign_in(user)
      visit question_path(question)
    end
    
    Capybara.using_session('user_1') do
      visit question_path(question)
    end

    Capybara.using_session('user') do
      fill_in 'Body', with: 'Body of answer'
      click_on 'Add answer'

      expect(page).to have_content 'Body of answer' 
    end

    Capybara.using_session('user_1') do
      expect(page).to have_content 'Body of answer' 
    end
  end
end
