require 'rails_helper'

feature 'User can delete links of question', %q{
In order to get answer from a community
As an authenticated user
I'd like to be able to delete links of question
} do

  given!(:user) { create(:user) }
  given!(:user_1) { create(:user) }
  given(:google_url) { 'http://google.com' }
  given!(:question) {create(:question, :with_link, user: user)}

  background do
    sign_in(user) 
    visit question_path(question)
  end
  
  context 'for author' do
    scenario 'delete link of question', js: true do
      within '.links-show' do
        click_on 'Delete Link'
      end

      expect(page).to_not have_content 'My google'
    end
  end

  context 'for not author' do
    scenario 'delete link of question', js: true do
      click_on 'Log Out'
      click_on 'Log In'
      sign_in(user_1) 
      visit question_path(question)
      within '.links-show' do
        expect(page).to_not have_content 'Delete Link'
      end
    end
  end
end
