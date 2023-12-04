class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update_password update]
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
  def update
    @user = User.find_by_id(params[:id])
    if @user.nil?
      render json: { error: 'This user is not found' }, status: :not_found
    elsif @user != current_resource_owner
      render json: { error: 'Forbidden' }, status: :forbidden
    else
      if params[:name].blank?
        render json: { error: 'The name is required.' }, status: :unprocessable_entity
      elsif params[:name].length > 100
        render json: { error: 'You cannot input more 100 characters.' }, status: :unprocessable_entity
      elsif params[:email] !~ URI::MailTo::EMAIL_REGEXP
        render json: { error: 'Invalid email format.' }, status: :unprocessable_entity
      else
        if @user.update(name: params[:name], email: params[:email])
          render json: { status: 200, user: { id: @user.id, name: @user.name, email: @user.email } }, status: :ok
        else
          render json: { error: 'Failed to update user' }, status: :unprocessable_entity
        end
      end
    end
  end
end
