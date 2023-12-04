class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update_password]
  def index
    @users = UserService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @users.total_pages
    @total_users = @users.count
    render 'index.json.jbuilder'
  end
  def show
    @user = User.find_by!('users.id = ?', params[:id])
    authorize @user, policy_class: Api::UsersPolicy
  end
  def update_password
    @user = User.find_by_id(params[:id])
    if @user.nil?
      render json: { error: 'User not found' }, status: :not_found
    else
      if @user.update(password: params[:password])
        render json: { message: 'Password updated successfully' }, status: :ok
      else
        render json: { error: 'Failed to update password' }, status: :unprocessable_entity
      end
    end
  end
end
