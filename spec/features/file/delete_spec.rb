require 'rails_helper'

feature 'User can remove files', %q{
  In order to correct mistakes
  As an author
  I'd like to be able to remove files
} do
  given!(:user) { create(:user) }
  given!(:user_1) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  background do
    sign_in user
    visit question_path(question)
  end

  describe 'answer' do
    background do
      within '.answers' do
        click_on 'Edit'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb"]
        click_on 'Save'
      end
    end

    describe 'for author' do
      scenario 'author remove file from answer ', js: true do
        within('.answers')  do
          click_on 'Remove file'
        
          expect(page).to_not have_link 'rails_helper.rb'
        end
      end
    end

    describe 'for not author' do
      scenario 'not author remove file from answer ', js: true do
          click_on 'Log Out'
          click_on 'Log In'
          sign_in(user_1) 
          visit questions_path
          click_on question.body

        within('.answers') do
          expect(page).to_not have_link 'Remove file'
        end
      end
    end
  end

  describe 'question' do
    background do
      within '.question' do
        click_on 'Edit'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb"]
        click_on 'Save'
      end
    end

    describe 'for author' do
      scenario 'author remove file from question ', js: true do
        within('.question') do
          click_on 'Remove file'
      
          expect(page).to_not have_link 'rails_helper.rb'
        end
      end
    end

    describe 'for not author' do
      scenario 'not author remove file from question ', js: true do
        click_on 'Log Out'
        click_on 'Log In'
        sign_in(user_1) 
        visit questions_path
        click_on question.body

        within('.question') do
          expect(page).to_not have_link 'Remove file'
        end
      end
    end
  end
end