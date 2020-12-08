require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask question
  As an unauthenticated user
  I'd like to be able to sign up
} do

  background { visit new_user_registration_path 
  clear_emails
  }

  scenario 'Unregistered user tries to sign up correctly' do
    fill_in 'Email', with: 'random@com.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'
    open_email('random@com.com')
    current_email.click_on 'Confirm my account'

    # expect(page).to have_content 'Your email address has been successfully confirmed.'
    fill_in 'Email', with: 'random@com.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'
    expect(page).to have_content 'Signed in successfully.'
  end
  
  scenario 'Unregistered user tries to sign up incorrectly' do
    click_on 'Sign up'
    expect(page).to have_content "Email can't be blank"
  end
end
