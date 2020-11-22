require 'rails_helper'

feature 'User can see new question in realtime', %q{
  In order to get information immediatly
  I'd like to able to get realtime information
} do
  
  given(:user) {create(:user)}
  given(:user_1) {create(:user)}
  given(:question) {create(:question)}

  describe 'Question' do
    scenario "it appears in another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end
      
      Capybara.using_session('user_1') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Add your comments for question', with: 'Comment body'
        
        click_on 'Add comment'

        expect(page).to have_content 'Comment body'
      end

      Capybara.using_session('user_1') do
        expect(page).to have_content 'Comment body'  
      end
    end
  end

  describe "Answer" do
    given(:answer) {create(:answer)}
    scenario "comment appears in another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end
      
      Capybara.using_session('user_1') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Add your comments for question', with: 'Comment body'
        
        click_on 'Add comment'

        expect(page).to have_content 'Comment body'
      end

      Capybara.using_session('user_1') do
        expect(page).to have_content 'Comment body'  
      end
    end
  end
  describe "Unauthorised user" do
    given!(:answer) { create(:answer, question: question) }

    background { visit question_path(question) }

    scenario "User can't create comment" do
      expect(page).to_not have_content 'Add comment'
    end
  end
end
