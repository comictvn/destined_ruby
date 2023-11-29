class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update_profile]
  before_action :set_user, only: %i[show update_profile]
  before_action :authorize_user, only: %i[show update_profile]
  def index
    @users = UserService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @users.total_pages
  end
  def show
  end
  def update_profile
    if @user.update(user_params)
      render json: {success: true, message: 'Profile updated successfully'}
    else
      render json: {success: false, message: @user.errors.full_messages.join(', ')}
    end
  end
  private
  def set_user
    @user = User.find_by!('users.id = ?', params[:id])
  end
  def authorize_user
    authorize @user, policy_class: Api::UsersPolicy
  end
  def user_params
    params.permit(:age, :gender, :location, :interests, :preferences)
  end
end
