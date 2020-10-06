require 'rails_helper'
feature 'User can add links to question', %q{
  In order to provide aditional info to my question
  As an question,s author
  I,d like to be able to add links
} do
  given(:user) { create(:user) }
  given(:google_url) { 'http://google.com' }

  scenario 'User adds valid link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Name', with: 'My google'
    fill_in 'Url', with: google_url

    click_on 'Ask'

    expect(page).to have_link 'My google', href: google_url
  end

  scenario 'User adds links when asks question', js: true do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'My question'
    fill_in 'Body', with: 'Why?'

    click_on 'add link'
    all('.nested-fields').each do |a|
      within a do
        fill_in 'Name', with: 'My google link'
        fill_in 'Url', with: google_url
      end
    end
    click_on 'Ask'

    within ".links-show" do
      expect(page.all('a', text: 'My google link').count).to eq 3
    end
  end

  scenario 'User adds not valid link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Name', with: 'My google'
    fill_in 'Url', with: 'www.google ru'

    click_on 'Ask'

    expect(page).to_not have_link 'My google'
    expect(page).to have_content 'Links url is invalid'
  end
end