require 'rails_helper'

feature 'User can see his rewards', %{
  In order to see his rewards
  As an author of answer
  I's like to able to see my rewards
} do 

  given!(:user) { create(:user) }
  given!(:user_1) { create(:user) }
  given!(:question) { create(:question, :with_reward, user: user) }
  given!(:answer) { create(:answer, question: question, user: user_1) }

  background do
    answer.best_assign
    sign_in(user_1)
  end
  
  scenario 'Authenticated user can see his rewards' do
    click_on 'My rewards'
    expect(page).to have_content question.title
    expect(page).to have_content question.reward.name
    # expect(page).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end