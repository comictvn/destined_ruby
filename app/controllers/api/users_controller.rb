class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update_profile matches update_preferences complete_profile swipes]
  before_action :set_user, only: [:matches, :update_preferences, :complete_profile]

  # Require both services as they might be used in different contexts
  require_dependency 'user_matching_service'
  require_dependency 'matchmaking_service'

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

    preferences = params[:preferences]
    unless preferences.is_a?(Hash)
      return render json: { error: 'Invalid preferences' }, status: :bad_request
    end

    begin
      # Assuming UserPreferenceService exists and handles the preferences update logic
      user_preference_service = UserPreferenceService.new(@user, preferences)

      if user_preference_service.update
        render json: { status: 200, message: 'Preferences updated successfully' }, status: :ok
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
    return render json: { error: 'User not found' }, status: :not_found unless @user
    authorize @user, policy_class: Api::UsersPolicy

    unless valid_complete_profile_params?
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

    render json: { status: 200, message: "Profile completed successfully." }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages.to_sentence }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  rescue Pundit::NotAuthorizedError
    render json: { error: "Not authorized to complete profile" }, status: :forbidden
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # GET /api/users/:user_id/matches
  def matches
    return render json: { error: 'User not found.' }, status: :not_found unless @user
    authorize @user, policy_class: Api::UsersPolicy

    begin
      # Use a conditional to determine which service to use based on some condition
      # For example, a feature flag, user preference, etc.
      # Here we assume a simple condition, but this should be replaced with a real one
      if use_new_matching_service?
        user_matching_service = UserMatchingService.new
        potential_matches = user_matching_service.find_potential_matches(@user.id)
      else
        matchmaking_service = MatchmakingService.new
        potential_matches = matchmaking_service.generate_potential_matches(@user.id)
      end

      formatted_matches = potential_matches.map do |match|
        {
          id: match[:match].id,
          age: match[:match].age, # Assuming the User model has an 'age' attribute
          gender: match[:match].gender,
          location: match[:match].location, # Assuming the User model has a 'location' attribute
          compatibility_score: match[:score],
          interests: match[:match].interests.pluck(:name) # Assuming the User model has_many :interests
        }
      end
      render json: { status: 200, matches: formatted_matches }, status: :ok
    rescue Pundit::NotAuthorizedError
      render json: { error: "Not authorized to view matches" }, status: :forbidden
    rescue StandardError => e
      render json: { error: "An unexpected error occurred: #{e.message}" }, status: :internal_server_error
    end
  end

  # POST /api/users/:user_id/swipes
  def swipes
    target_user = User.find_by(id: swipe_params[:target_user_id])
    return render json: { error: 'User not found' }, status: :not_found unless target_user

    action = swipe_params[:action]
    unless %w[like pass].include?(action)
      return render json: { error: 'Invalid action' }, status: :bad_request
    end

    # Assuming SwipeService exists and handles the swipe logic
    result = SwipeService.new(current_resource_owner, target_user, action).perform
    if result.success?
      render json: { status: 201, message: 'Swipe action recorded successfully.' }, status: :created
    else
      render json: { error: result.error }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  # ... existing private methods ...

  def swipe_params
    params.permit(:target_user_id, :action)
  end

  def valid_complete_profile_params?
    valid_update_profile_params? && valid_preferences_params?(params[:preferences]) && params[:interests].is_a?(Array)
  end

  def set_user
    @user = User.find(params[:user_id] || params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  # Add a method to determine which matching service to use
  def use_new_matching_service?
    # Placeholder condition, replace with actual logic
    true
  end
end
