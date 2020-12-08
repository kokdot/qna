class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    call_provider('Github')
  end

  def facebook
    call_provider('Facebook')
  end

  def twitter
    call_provider('Twitter')
  end

private

  def call_provider(provider)
    @auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(@auth)
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    elsif @auth != :invalid_credential && @auth != nil
      session[:auth] = @auth
      @user = User.new
      redirect_to users_email_get_path
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
