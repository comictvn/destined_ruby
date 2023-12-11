class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update_profile matches update_preferences complete_profile swipes]
  before_action :set_user, only: [:matches, :update_preferences, :complete_profile]
  before_action :authenticate_user!, only: [:update_preferences] # Added before_action to authenticate user
  before_action :validate_preferences, only: [:update_preferences] # Added before_action to validate preferences

  require_dependency 'matchmaking_service'
  require_dependency 'user_service/update_profile' # Import the UserService::UpdateProfile class

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
    # ... existing update_profile method ...
  end

  # PUT /api/users/:user_id/preferences
  def update_preferences
    return render json: { error: 'User not found' }, status: :not_found unless @user

    preferences = params[:preference_data] # Changed from params[:preferences] to params[:preference_data]
    unless preferences.is_a?(Hash)
      return render json: { error: 'Invalid preferences' }, status: :bad_request
    end

    begin
      # Assuming UserPreferenceService exists and handles the preferences update logic
      user_preference_service = UserPreferenceService.new(@user, preferences)

      if user_preference_service.update
        MatchmakingService.new.refresh_matches_for(@user) # Call to matchmaking service to refresh matches
        render json: { status: 200, message: 'Preferences updated successfully', preferences: user_preference_service.preferences }, status: :ok
      else
        render json: { error: user_preference_service.errors.full_messages.to_sentence }, status: :unprocessable_entity
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
  def swipes
    # ... existing swipes method ...
  end

  private

  # ... existing private methods ...

  def authenticate_user!
    # Assuming there's a method to authenticate the user
    render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user && current_user.id == params[:user_id].to_i
  end

  def validate_preferences
    preferences = params[:preference_data]
    unless preferences.is_a?(Hash) && preferences.keys.all? { |k| k.is_a?(String) }
      render json: { error: 'Invalid preferences format' }, status: :bad_request
    end
    # Add more validation rules as needed
  end

  def set_user
    @user = User.find_by(id: params[:user_id] || params[:id])
  end

  # ... rest of the file ...
end
