
class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update]

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from Pundit::NotAuthorizedError, with: :render_unauthorized

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
    user = User.find(params[:user_id])
    authorize user, :update?

    if user.update(user_params)
      render_response(resource: user)
    else
      render_error(errors: user.errors.full_messages)
    end
  end

  private

  def user_params
    params.permit(:name, :email, :bio)
  end
end
