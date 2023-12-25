class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update_preferences update_profile]
  before_action :authenticate_user, only: [:matches]
  before_action :set_user, only: [:update_preferences, :update_profile]

  def index
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

  def update_profile
    profile_params = params.require(:user).permit(:age, :gender, :location, :interests, :preferences)

    unless valid_profile_params?(profile_params)
      return render json: { error: @error_message }, status: error_status(@error_message)
    end

    service = UserProfileService.new(@user.id, profile_params)
    result = service.update_user_profile

    if result[:success]
      render json: { status: 200, message: 'Profile updated successfully.' }, status: :ok
    else
      render json: { error: result[:error] }, status: error_status(result[:error])
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

  def valid_profile_params?(profile_params)
    @error_message = nil
    @error_message ||= 'User not found.' unless User.exists?(profile_params[:id])
    @error_message ||= 'Invalid age.' unless profile_params[:age].to_i.positive?
    @error_message ||= 'Invalid gender.' unless User.genders.keys.include?(profile_params[:gender])
    @error_message ||= 'Invalid location.' unless profile_params[:location].is_a?(String)
    @error_message ||= 'Invalid interests.' unless profile_params[:interests].is_a?(Array) && profile_params[:interests].all? { |i| i.is_a?(String) }
    @error_message ||= 'Invalid preferences.' unless valid_json?(profile_params[:preferences])
    @error_message.nil?
  end

  def valid_json?(json)
    JSON.parse(json)
    true
  rescue JSON::ParserError
    false
  end

  def error_status(error_message)
    case error_message
    when 'User not found'
      :not_found
    when 'Invalid age', 'Invalid gender', 'Invalid location', 'Invalid interests', 'Invalid preferences'
      :unprocessable_entity
    else
      :internal_server_error
    end
  end
end
