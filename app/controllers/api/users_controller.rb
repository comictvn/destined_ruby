class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show]
  def index
    @users = User.all
    @total_users = @users.count
    render 'index.json.jbuilder'
  end
  def show
    @user = User.find_by!('users.id = ?', params[:id])
    authorize @user, policy_class: Api::UsersPolicy
  end
end
