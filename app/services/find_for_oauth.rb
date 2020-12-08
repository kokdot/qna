class Services::FindForOauth
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first if email
    if user
      user.create_authorization(auth)
    elsif email 
      password = Devise.friendly_token[0, 20]
      user = User.new(
        confirmed_at: Time.now,
        email: email,
        password: password, 
        password_confirmation: password
      )
      user.save!
      user.create_authorization(auth)
    end
    user
  end
end
