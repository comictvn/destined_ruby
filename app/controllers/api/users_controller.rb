class Api::UsersController < ApplicationController
  before_action :authenticate_user!, only: [:update]
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
  def update
    user = current_user
    if user.update(user_params)
      user.send_confirmation_instructions
      render json: { message: 'User profile updated successfully. Please confirm your email.' }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
