class LoginCounter < Counter
  def initialize(email)
    super('login',
          { attempts: Figaro.env.LOGIN_ATTEMPTS.to_i,
            interval: Figaro.env.LOGIN_INTERVAL_IN_SECONDS.to_i,
            expires_in: Figaro.env.LOGIN_EXPIRY_IN_SECONDS.to_i,
            key: email} )
  end
end