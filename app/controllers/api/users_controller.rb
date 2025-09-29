class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show]

  def index
    # inside service params are checked and whiteisted
    @users = UserService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @users.total_pages
  end

  def show
    @user = User.find_by!('users.id = ?', params[:id])

    authorize @user, policy_class: Api::UsersPolicy
  end

  def sign_in
    email_or_phone = params[:emailOrPhone]
    password = params[:password]
    user = User.authenticate?(email_or_phone, password)

    if user
      custom_token_initialize_values(user)
      user.update!(
        current_sign_in_at: Time.current,
        last_sign_in_at: user.current_sign_in_at,
        current_sign_in_ip: request.remote_ip,
        last_sign_in_ip: user.current_sign_in_ip,
        sign_in_count: user.sign_in_count + 1
      )
      render_response({ token: @access_token, userId: user.id })
    else
      render_error('invalid_credentials', status: :unauthorized)
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
  end
end