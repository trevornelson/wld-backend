class ValidateToken
  prepend SimpleCommand
  
  def initialize(token)
    @token = token
  end

  def call
    user
  end

  private

  def user
    @user ||= decoded_token['user'] if decoded_token && token_not_expired?
    @user || errors.add(:token, 'Expired token') && nil
  end

  def decoded_token
    return unless @token
    @decoded_token ||= JsonWebToken.decode(@token)
  end

  def token_not_expired?
    token_expiration > Time.now.to_i
  end

  def token_expiration
    @token_expiration ||= decoded_token['exp']
  end
end
