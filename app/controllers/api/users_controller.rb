class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update_preferences]
  before_action :authenticate_user, only: [:matches]
  before_action :set_user, only: [:update_preferences]

  def index
    # inside service params are checked and whiteisted
    @users = UserService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @users.total_pages
  end

  def show
    @user = User.find_by!('users.id = ?', params[:id])

    authorize @user, policy_class: Api::UsersPolicy
  end

  def matches
    user = User.find_by(id: params[:id])
    return render json: { error: 'User not found.' }, status: :not_found unless user

    potential_matches = UserMatchingService.new(user).find_potential_matches
    render json: { status: 200, matches: potential_matches }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # PUT /api/users/:id/preferences
  def update_preferences
    service = PreferencesService.new
    result = service.update_user_preferences(@user.id, preferences_params)

    case result[:status]
    when :ok
      render json: { status: 200, message: 'Preferences updated successfully.' }, status: :ok
    when :not_found
      render json: { status: 404, message: 'User not found.' }, status: :not_found
    when :invalid
      render json: { status: 422, message: 'Invalid preferences.', errors: result[:errors] }, status: :unprocessable_entity
    else
      render json: { status: 500, message: 'Internal Server Error' }, status: :internal_server_error
    end
  end

  private

  def authenticate_user
    # Authentication logic here, refer to Api::BaseController for examples
  end

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { status: 404, message: 'User not found.' }, status: :not_found
  end

  def preferences_params
    params.require(:preference_data).permit(:age_range, :distance, :gender)
  end
end
