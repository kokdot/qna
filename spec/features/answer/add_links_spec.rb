require 'rails_helper'
feature 'User can add links to answer', %q{
  In order to provide aditional info to my answer
  As an answer,s author
  I,d like to be able to add links
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:google_url) { 'http://google.com' }
  given(:gist_url) { 'https://gist.github.com/kokdot/c9f487f59bdf339d175365be69fb9100.js' }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds links when asks answer', js: true do
    click_on 'add link'

    fill_in 'Body', with: 'My answer'
    all('.nested-fields').each do |a|
      within a do
        fill_in 'Name', with: 'My google'
        fill_in 'Url', with: google_url
      end
    end
    click_on 'Add answer'

    within ".answers" do
      all('li').each do |a|
        within a do
          expect(page).to have_link 'My google', href: google_url
        end
      end
    end
  end

  scenario 'User adds not valid link when asks answer', js: true do
    fill_in 'Body', with: 'My answer'
    fill_in 'Name', with: 'My google'
    fill_in 'Url', with: 'www.google ru'
    
    click_on 'Add answer'

    expect(page).to_not have_link 'My google'
    expect(page).to have_content 'Links url is invalid'
  end

  scenario 'User add link to gist',js: true do
    fill_in 'Body', with: 'My answer'
    fill_in 'Name', with: 'My gist'
    fill_in 'Url', with: gist_url
    
    click_on 'Add answer'
    page.evaluate_script 'window.location.reload()'

    expect(page).to have_content 'Hello World!'
  end
end
