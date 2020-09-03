require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask question
  As an unauthenticated user
  I'd like to be able to sign up
} do

  background { visit new_user_registration_path }

  scenario 'Unregistered user tries to sign up correctly' do
    fill_in 'Email', with: 'random@com.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
  
  scenario 'Unregistered user tries to sign up incorrectly' do
    click_on 'Sign up'
    expect(page).to have_content "Email can't be blank"
  end

end