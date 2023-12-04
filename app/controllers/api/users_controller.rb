class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show]
  def index
    @users = User.all
    @total_users = @users.count
    render json: { users: @users, total_users: @total_users }
  end
  def show
    @user = User.find_by!('users.id = ?', params[:id])
    authorize @user, policy_class: Api::UsersPolicy
  end
end
