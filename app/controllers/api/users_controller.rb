class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update_profile matches update_preferences complete_profile swipes record_swipe]
  before_action :set_user, only: [:matches, :update_preferences, :complete_profile, :record_swipe]
  before_action :authenticate_user!, only: [:update_preferences, :record_swipe] # authenticate_user! is now used for :record_swipe as well
  before_action :validate_preferences, only: [:update_preferences] # validate_preferences is used here
  before_action :validate_swipe_action, only: [:record_swipe] # Added before_action to validate swipe action

  require_dependency 'matchmaking_service'
  require_dependency 'user_service/update_profile' # Import the UserService::UpdateProfile class
  require_dependency 'user_preference_service' # Import the UserPreferenceService class

  # ... existing methods ...

  def index
    @users = UserService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @users.total_pages
  end

  def show
    @user = User.find_by!('users.id = ?', params[:id])
    authorize @user, policy_class: Api::UsersPolicy
  end

  # ... other existing methods ...

  # PUT /api/users/:id/profile
  def update_profile
    # ... existing update_profile method ...
  end

  # PUT /api/users/:user_id/preferences
  def update_preferences
    return render json: { error: 'User not found' }, status: :not_found unless @user

    preferences = params[:preferences] || params[:preference_data] # Support both :preferences and :preference_data
    interests = params[:interests]

    unless preferences.is_a?(String) && valid_interests_params?(interests)
      return render json: { error: 'Invalid preferences or interests' }, status: :bad_request
    end

    begin
      ActiveRecord::Base.transaction do
        # Assuming UserPreferenceService exists and handles the preferences update logic
        user_preference_service = UserPreferenceService.new(@user, preferences, interests)

        if user_preference_service.update
          MatchmakingService.new.refresh_matches_for(@user) # Call to matchmaking service to refresh matches
          render json: { status: 200, message: 'Preferences updated successfully', preferences: user_preference_service.preferences, interests: interests }, status: :ok
        else
          render json: { error: user_preference_service.errors.full_messages.to_sentence }, status: :unprocessable_entity
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.record.errors.full_messages.to_sentence }, status: :unprocessable_entity
    rescue Pundit::NotAuthorizedError
      render json: { error: 'Not authorized to update preferences' }, status: :forbidden
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
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
    # ... existing record_swipe method ...
  end

  private

  # ... existing private methods ...

  def authenticate_user!
    # ... existing authenticate_user! method ...
  end

  def validate_preferences
    preferences = params[:preferences] || params[:preference_data]
    unless preferences.is_a?(String) || (preferences.is_a?(Hash) && preferences.keys.all? { |k| k.is_a?(String) })
      render json: { error: 'Invalid preferences format' }, status: :bad_request
    end
    # Add more validation rules as needed
  end

  def set_user_by_id
    # ... existing set_user_by_id method ...
  end

  def valid_update_profile_params?
    # ... existing valid_update_profile_params? method ...
  end

  def valid_interests_params?(interests)
    interests.is_a?(Array) && interests.all? do |interest_name|
      Interest.exists?(name: interest_name)
    end
  end

  def valid_preferences_params?(preferences)
    # ... existing valid_preferences_params? method ...
  end

  def set_user
    @user = User.find_by(id: params[:user_id] || params[:id])
  end

  def swipe_params
    # ... existing swipe_params method ...
  end

  def validate_swipe_action
    # ... existing validate_swipe_action method ...
  end

  def valid_complete_profile_params?
    # ... existing valid_complete_profile_params? method ...
  end

  # ... rest of the file ...
end
