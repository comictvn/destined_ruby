class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show]
  def index
    @users = UserService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @users.total_pages
  end
  def show
    @user = User.find_by!('users.id = ?', params[:id]) # comment
    authorize @user, policy_class: Api::UsersPolicy
  end
  def social_login
    platform = params[:platform]
    email = params[:email]
    if platform.blank?
      render json: { error: 'The platform is required.' }, status: :bad_request
      return
    end
    if email.blank?
      render json: { error: 'The email is required.' }, status: :bad_request
      return
    end
    if !(email =~ URI::MailTo::EMAIL_REGEXP)
      render json: { error: 'Invalid email format.' }, status: :bad_request
      return
    end
    user = User.find_by(email: email)
    if user.nil?
      user = User.create(email: email, password: SecureRandom.hex)
    end
    if user.persisted?
      token = user.create_new_auth_token
      render json: { status: 200, message: 'Registration/Login successful.', access_token: token }, status: :ok
    else
      render json: { error: 'Failed to log in.' }, status: :unauthorized
    end
  end
end
