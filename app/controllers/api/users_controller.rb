class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update_profile matches update_preferences complete_profile swipes record_swipe]
  before_action :set_user, only: [:matches, :update_preferences, :complete_profile, :record_swipe]
  before_action :authenticate_user!, only: [:update_preferences, :record_swipe] # Added :record_swipe to the array
  before_action :validate_preferences, only: [:update_preferences]
  before_action :validate_swipe_action, only: [:record_swipe] # Added before_action to validate swipe action

  require_dependency 'matchmaking_service'
  require_dependency 'user_service/update_profile'

  # ... existing methods ...

  def index
    @users = UserService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @users.total_pages
  end

  def show
    @user = User.find_by!('users.id = ?', params[:id])
    authorize @user, policy_class: Api::UsersPolicy
  end

  # PUT /api/users/:id/profile
  def update_profile
    return render json: { error: 'User not found' }, status: :not_found unless set_user_by_id

    unless valid_update_profile_params?
      render json: { error: "Invalid parameters" }, status: :bad_request
      return
    end

    ActiveRecord::Base.transaction do
      UserService::UpdateProfile.new(
        user_id: @user.id,
        age: params[:age],
        gender: params[:gender],
        location: params[:location]
      ).execute

      params[:interests].each do |interest_name|
        interest = Interest.find_or_create_by!(name: interest_name)
        UserInterest.find_or_create_by!(user: @user, interest: interest)
      end

      user_preference = @user.user_preference || @user.build_user_preference
      user_preference.update!(preference_data: params[:preferences])
    end

    render json: { status: 200, message: "Profile updated successfully." }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages.to_sentence }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  rescue Pundit::NotAuthorizedError
    render json: { error: "Not authorized to update profile" }, status: :forbidden
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # PUT /api/users/:user_id/preferences
  def update_preferences
    return render json: { error: 'User not found' }, status: :not_found unless @user

    preferences_params = params.require(:preferences).permit(:age_range, :distance, :gender) rescue nil
    preferences_params ||= params[:preference_data] # Fallback to :preference_data if :preferences is missing

    # Ensure the user is authorized to update these preferences
    authorize! :update, @user
    
    # Update preferences using the service
    service = UserPreferenceService.new(@user, preferences_params.to_h)
    if service.update
      MatchmakingService.new.refresh_matches_for(@user) # Call to matchmaking service to refresh matches
      render json: { status: 200, message: "Preferences updated successfully.", preferences: service.preferences }, status: :ok
    else
      render json: { status: 422, message: service.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  rescue ActionController::ParameterMissing
    render json: { status: 400, message: "Invalid preferences." }, status: :bad_request
  rescue Pundit::NotAuthorizedError
    render json: { status: 403, message: "Not authorized to update preferences" }, status: :forbidden
  rescue => e
    render json: { status: 500, message: e.message }, status: :internal_server_error
  end

  # PUT /api/users/:user_id/profile/complete
  def complete_profile
    # ... existing complete_profile method ...
  end

  # GET /api/users/:user_id/matches
  def matches
    # ... existing matches method ...
  end

  # POST /api/users/:user_id/swipes
  def record_swipe
    return render json: { error: 'User not found' }, status: :not_found unless @user

    target_user = User.find_by(id: swipe_params[:target_user_id])
    return render json: { error: 'User not found' }, status: :not_found unless target_user

    action = swipe_params[:action]
    return render json: { error: 'Invalid swipe action' }, status: :bad_request unless %w[left right].include?(action)

    result = MatchmakingService.new.record_swipe_action(@user.id, target_user.id, action)

    if result[:success]
      render json: { status: 200, message: 'Swipe action recorded successfully.' }, status: :ok
    else
      render json: { status: 422, message: result[:message] }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { status: 500, message: "An unexpected error occurred: #{e.message}" }, status: :internal_server_error
  end

  private

  # ... existing private methods ...

  def authenticate_user!
    # Assuming there's a method to authenticate the user
    render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user && current_user.id == params[:user_id].to_i
  end

  def validate_preferences
    preferences = params[:preference_data] || params[:preferences]
    unless preferences.is_a?(Hash) && preferences.keys.all? { |k| k.is_a?(String) }
      render json: { error: 'Invalid preferences format' }, status: :bad_request
    end
    # Add more validation rules as needed
  end

  def set_user_by_id
    @user = User.find_by(id: params[:user_id] || params[:id])
  end

  def valid_update_profile_params?
    params[:age].is_a?(Integer) && params[:age] > 0 &&
    User.genders.keys.include?(params[:gender]) &&
    params[:location].is_a?(String) &&
    valid_interests_params?(params[:interests]) &&
    valid_preferences_params?(params[:preferences])
  end

  def valid_interests_params?(interests)
    interests.is_a?(Array) && interests.all? { |i| i.is_a?(String) }
  end

  def valid_preferences_params?(preferences)
    preferences.is_a?(Hash) &&
    preferences['age_range'].is_a?(Array) &&
    preferences['age_range'].size == 2 &&
    preferences['age_range'].all? { |i| i.is_a?(Integer) } &&
    preferences['distance'].is_a?(Integer) &&
    preferences['gender'].is_a?(Array) &&
    preferences['gender'].all? { |i| User.genders.keys.include?(i) }
  end

  def set_user
    @user = User.find_by(id: params[:user_id] || params[:id])
  end

  def swipe_params
    params.require(:swipe).permit(:target_user_id, :action)
  end

  def validate_swipe_action
    swipe = swipe_params
    unless swipe[:target_user_id].present? && swipe[:action].present?
      render json: { error: 'Missing swipe parameters' }, status: :bad_request
    end
  end

  def valid_complete_profile_params?
    # ... existing valid_complete_profile_params? method ...
  end

  # ... rest of the file ...
end
