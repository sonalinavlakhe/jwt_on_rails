class ApplicationController < ActionController::Base
	# protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
require 'jsonwebtoken'
skip_before_action :verify_authenticity_token

protected
# Validates the token and user and sets the @current_user scope
def authenticate_request!
	logger = Rails.logger
	logger.info 'Payload'
  if !payload || !JsonWebToken.valid_payload(payload.first)
    return invalid_authentication
  end
  logger.info payload.first

  load_current_user!
  invalid_authentication unless @current_user
end

# Returns 401 response. To handle malformed / invalid requests.
def invalid_authentication
  render json: {error: 'Invalid Request'}, status: :unauthorized
end

private
# Deconstructs the Authorization header and decodes the JWT token.
def payload
  auth_header = request.headers['Authorization']
  token = auth_header.split(' ').last
  JsonWebToken.decode(token)
rescue
  nil
end

# Sets the @current_user with the user_id from payload
def load_current_user!
  @current_user = User.find_by(id: payload[0]['user_id'])
end

end
