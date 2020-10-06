require 'rails_helper'

feature 'User can create question with reward', %q{
In order to get answer from a community
As an authenticated user
I'd like to be able to ask the question with reward
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
  end
  scenario 'User asks a question with reward' , js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    fill_in 'Reward Name', with: 'Reward for the best answer'
    attach_file 'Reward file', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Ask'
    
    within '.reward' do
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_content 'Reward for the best answer'
    end
  end
end