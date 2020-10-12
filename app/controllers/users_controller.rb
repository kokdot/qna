class UsersController < ApplicationController
  before_action :load_user, only: [:show]
  def show
    @rewards = Reward.where(answer_id: @user.answers)
  end

  private

  def load_user
    @user = current_user
  end
end
