require 'rails_helper'

feature 'User can sign in with social network', %q{
  In order to use oppotunities of website 
  to authenticte user. I'd like to able
  to authorization from social networks
} do
  
  describe 'GitHub' do
    
    background do 
      visit new_user_session_path
      clean_mock_auth('github')
    end
    
    describe 'Registered user' do
      let(:user) { create(:user) }

      scenario 'try to sign in' do
        mock_auth_hash('github', email: 'user1@test.com')
        click_on "Sign in with GitHub"
        
        expect(page).to have_content "Successfully authenticated from Github account."
      end

      scenario 'try to sign in with failure' do
        failure_mock_auth('github')
        click_on "Sign in with GitHub"

        expect(page).to have_content "Could not authenticate you from GitHub because \"Invalid credential\"."
      end
    end

    describe 'Unregistered user' do
      scenario 'try to sign in' do
        mock_auth_hash('github', email: 'user1@test.com')
        click_on "Sign in with GitHub"
        
        expect(page).to have_content "Successfully authenticated from Github account."
      end
    end
  end

  describe 'Twitter no email' do
    
    background do 
      visit new_user_session_path
      clear_emails
      clean_mock_auth('twitter')
    end

    scenario 'try to sign in' do
      mock_auth_hash('twitter', email: nil)
      fill_in 'Email', with: 'user1@test.com'
      click_on "Sign in with Twitter"
      fill_in 'Email', with: 'user1@test.com'
      click_on 'Continue'
      open_email('user1@test.com')
      current_email.click_on 'Confirm my account'
      fill_in 'Email', with: 'user1@test.com'
      click_on "Sign in with Twitter"
      
      expect(page).to have_content "Successfully authenticated from Twitter account."
    end

  end
end
