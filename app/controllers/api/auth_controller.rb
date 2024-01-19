class Api::AuthController < Api::BaseController
  include UserService

  def login
    username = params[:username]
    password = params[:password]

    # Updated validation messages as per requirement
    raise Exceptions::BadRequest, 'Username is required.' if username.blank?
    raise Exceptions::BadRequest, 'Password is required.' if password.blank?

    user = User.authenticate?(username, password)

    if user
      # Updated the success message and status code as per requirement
      token = LoginOtp.new(user.phone_number).call
      render json: { status: 200, message: 'User authenticated successfully.', access_token: token }, status: :ok
    else
      # Updated the unauthorized status code as per requirement
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  rescue => e
    # Updated the error handling to match the requirement
    case e
    when Exceptions::BadRequest
      render json: { error: e.message }, status: :bad_request
    else
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
