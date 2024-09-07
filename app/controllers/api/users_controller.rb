class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show]
  before_action :validate_designer_permissions, only: %i[create update destroy]

  def index
    # inside service params are checked and whiteisted
    @users = UserService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @users.total_pages
  end

  def show
    @user = User.find_by!('users.id = ?', params[:id])

    authorize @user, policy_class: Api::UsersPolicy
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
  end

  private

  def validate_designer_permissions
    user = current_resource_owner
    policy = Api::UsersPolicy.new(user, nil)
    raise Exceptions::AuthorizationError unless policy.designer?
  end

end