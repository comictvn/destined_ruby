class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update_profile matches update_preferences complete_profile swipes record_swipe]
  before_action :set_user, only: [:matches, :update_preferences, :complete_profile, :record_swipe, :update_profile] # Combined set_user actions
  before_action :authenticate_user!, only: [:update_preferences, :record_swipe, :update_profile] # Combined authenticate_user! actions
  before_action :validate_preferences, only: [:update_preferences] # validate_preferences is used here
  before_action :validate_swipe_action, only: [:record_swipe] # validate_swipe_action is used here
  before_action :validate_complete_profile, only: [:update_profile] # Added before_action to validate complete profile data

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
    return render json: { error: 'User not found' }, status: :not_found unless @user

    unless valid_update_profile_params?
      return render json: { error: 'Invalid profile data' }, status: :bad_request
    end

    interests = params[:interests]
    preferences = params[:preferences]

    begin
      ActiveRecord::Base.transaction do
        # Update user's age, gender, location
        @user.update!(age: params[:age], gender: params[:gender], location: params[:location])

        # Handle interests
        interests.each do |interest_name|
          interest = Interest.find_or_create_by!(name: interest_name)
          UserInterest.find_or_create_by!(user: @user, interest: interest)
        end

        # Update preferences using UserPreferenceService
        UserPreferenceService.new(@user).update_preferences(preferences)

        render json: { status: 200, message: 'Profile updated successfully', user: @user.as_json.merge(interests: interests, preferences: preferences) }, status: :ok
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.record.errors.full_messages.to_sentence }, status: :unprocessable_entity
    rescue Pundit::NotAuthorizedError
      render json: { error: 'Not authorized to update profile' }, status: :forbidden
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  # ... rest of the existing methods ...

  private

  # ... existing private methods ...

  def authenticate_user!
    # Assuming there's a method to authenticate the user
    render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user && current_user.id == params[:user_id].to_i
  end

  def validate_preferences
    preferences = params[:preference_data] || params[:preferences]
    unless preferences.is_a?(Hash) && preferences.keys.all? { |k| k.is_a?(String) } || preferences.is_a?(String)
      render json: { error: 'Invalid preferences format' }, status: :bad_request
    end
    # Add more validation rules as needed
  end

  def set_user
    @user = User.find_by(id: params[:user_id] || params[:id])
  end

  def validate_complete_profile
    unless params[:age].is_a?(Integer) && params[:age] > 0
      render json: { error: 'Invalid age.' }, status: :bad_request and return
    end

    unless User.genders.keys.include?(params[:gender])
      render json: { error: 'Invalid gender type.' }, status: :bad_request and return
    end

    unless params[:location].is_a?(String)
      render json: { error: 'Invalid location format.' }, status: :bad_request and return
    end

    unless valid_interests_params?(params[:interests])
      render json: { error: 'Invalid interests.' }, status: :bad_request and return
    end

    unless valid_preferences_params?(params[:preferences])
      render json: { error: 'Invalid preferences format.' }, status: :bad_request and return
    end
  end

  def valid_update_profile_params?
    params[:age].is_a?(Integer) && params[:gender].present? && params[:location].is_a?(String) && valid_interests_params?(params[:interests]) && valid_preferences_params?(params[:preferences])
  end

  def valid_interests_params?(interests)
    interests.is_a?(Array) && interests.all? { |i| i.is_a?(String) }
  end

  def valid_preferences_params?(preferences)
    preferences.is_a?(String)
  end

  def swipe_params
    params.permit(:target_user_id, :action)
  end

  def validate_swipe_action
    # ... existing validate_swipe_action method ...
  end

  def valid_complete_profile_params?
    # ... existing valid_complete_profile_params? method ...
  end

  # ... rest of the file ...
end
