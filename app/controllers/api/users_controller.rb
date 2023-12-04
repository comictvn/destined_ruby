class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show]
  def index
    @users = User.all
    @total_users = @users.count
    render json: { status: 200, users: @users.as_json(only: [:id, :name, :phone_number, :password]), total_users: @total_users }
  end
  def show
    @user = User.find_by!('users.id = ?', params[:id])
    authorize @user, policy_class: Api::UsersPolicy
    render json: @user
  end
end
