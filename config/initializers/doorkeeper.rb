Doorkeeper.configure do
  # Change the ORM that doorkeeper will use (requires ORM extensions installed).
  # Check the list of supported ORMs here: https://github.com/doorkeeper-gem/doorkeeper#orms
  orm :active_record
  resource_owner_authenticator do
    session[:user_return_to] = request.fullpath
    current_resource_owner || redirect_to(login_url)
  end
  resource_owner_from_credentials do |_routes|
    resource = nil
    if params[:scope].present?
      # first loop
      if params[:email].present? && params[:password].present?
        case params[:scope]
        when 'users'
          resource = User.authenticate?(params[:email], params[:password])
        end
      end
      if params[:phone_number].present? && params[:otp_code].present?
        case params[:scope]
        when 'users'
          resource = User.verify_otp?(params[:phone_number], params[:otp_code])
        end
      end
    else
      resource = User.authenticate?(params[:email], params[:password])
    end
    resource
  end
  access_token_class 'CustomAccessToken'
  allow_blank_redirect_uri true
  use_polymorphic_resource_owner
  access_token_expires_in 2.hours
  use_refresh_token
  grant_flows %w[authorization_code client_credentials password assertion]
  # Configure Doorkeeper to handle the authentication and authorization for the "/api/users/register" endpoint.
  # Only allow access to this endpoint for authenticated and authorized users.
  before_successful_strategy_response do |request|
    if request.path == '/api/users/register'
      raise Doorkeeper::Errors::InvalidToken unless current_resource_owner
    end
  end
end
