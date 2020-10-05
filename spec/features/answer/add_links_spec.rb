require 'rails_helper'
feature 'User can add links to answer', %q{
  In order to provide aditional info to my answer
  As an answer,s author
  I,d like to be able to add links
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:google_url) { 'http://google.com' }

  scenario 'User adds link when asks answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'My answer'

    fill_in 'Name', with: 'My google'
    fill_in 'Url', with: google_url
    
    click_on 'Add answer'

    within '.answers' do
      expect(page).to have_link 'My google', href: google_url
    end
  end

  scenario 'User adds links when asks answer', js: true do
    sign_in(user)
    visit question_path(question)
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
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'My answer'

    fill_in 'Name', with: 'My google'
    fill_in 'Url', with: 'www.google ru'
    
    click_on 'Add answer'

    expect(page).to_not have_link 'My google'
    expect(page).to have_content 'Links url is invalid'
  end
end