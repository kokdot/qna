class UsersController < ApplicationController
  before_action :load_user, only: [:show]
  def show
    @rewards = Reward.where(answer_id: @user.answers)
  end

  def email_get
    @user = User.new
  end

  def email_post
    password = Devise.friendly_token[0, 20]
    @user = User.create!(
      email: params[:user][:email],
      password: password, 
      password_confirmation: password
    )
    auth = session[:auth]
    @user.authorizations.create(provider: auth['provider'], uid: auth['uid']) 
    bypass_sign_in(@user)
  end

  private

  def load_user
    @user = current_user
  end
end
