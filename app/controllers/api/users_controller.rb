class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update_profile matches update_preferences complete_profile]
  before_action :set_user, only: [:matches, :update_preferences, :complete_profile]

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
    unless valid_update_profile_params?
      render json: { error: "Invalid parameters" }, status: :bad_request
      return
    end

    service = UserService::UpdateProfile.new(
      user_id: params[:id],
      age: params[:age],
      gender: params[:gender],
      location: params[:location],
      interests: params[:interests],
      answers: params[:answers]
    )
    
    result = service.update_profile
    
    if result[:error].present?
      render json: { error: result[:error] }, status: :unprocessable_entity
    else
      render json: { status: 200, message: "Profile updated successfully." }, status: :ok
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  # PUT /api/users/:user_id/preferences
  def update_preferences
    return render json: { error: 'User not found' }, status: :not_found unless @user
    authorize @user, policy_class: Api::UsersPolicy

    preference_data = params.require(:preferences)

    unless valid_preferences_params?(preference_data)
      render json: { error: "Invalid preference data" }, status: :bad_request
      return
    end

    service = UserService::UpdatePreferences.new(
      user_id: @user.id,
      preferences: preference_data
    )

    result = service.update_preferences

    if result[:error].present?
      render json: { error: result[:error] }, status: :unprocessable_entity
    else
      MatchmakingService.new.refresh_suggested_matches_for_user(@user.id)
      render json: { status: 200, message: "Preferences updated successfully." }, status: :ok
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  rescue Pundit::NotAuthorizedError
    render json: { error: "Not authorized to update preferences" }, status: :forbidden
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # PUT /api/users/:user_id/profile
  def complete_profile
    return render json: { error: 'User not found' }, status: :not_found unless @user
    authorize @user, policy_class: Api::UsersPolicy

    unless valid_complete_profile_params?
      render json: { error: "Invalid parameters" }, status: :bad_request
      return
    end

    service = UserService::UpdateProfile.new(
      user_id: @user.id,
      age: params[:age],
      gender: params[:gender],
      location: params[:location],
      interests: params[:interests],
      answers: params[:answers],
      preferences: params[:preferences]
    )
    
    result = service.update_profile
    
    if result[:error].present?
      render json: { error: result[:error] }, status: :unprocessable_entity
    else
      render json: { status: 200, message: "Profile completed successfully." }, status: :ok
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  rescue Pundit::NotAuthorizedError
    render json: { error: "Not authorized to complete profile" }, status: :forbidden
  end

  def matches
    return render json: { error: 'User not found.' }, status: :bad_request unless @user

    potential_matches = MatchmakingService.new.generate_potential_matches(@user.id)
    formatted_matches = potential_matches.map do |match|
      {
        id: match[:match].id,
        age: match[:match].age,
        gender: match[:match].gender,
        location: match[:match].location,
        compatibility_score: match[:score]
      }
    end

    render json: { status: 200, matches: formatted_matches }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def doorkeeper_authorize!
    # Implement user authentication logic here, possibly using OAuthTokensConcern
  end

  def set_user
    @user = User.find_by(id: params[:user_id] || params[:id])
  end

  def valid_update_profile_params?
    # Validate age
    return false unless params[:age].is_a?(Integer) && params[:age] > 0
    # Validate gender
    return false unless User.genders.keys.include?(params[:gender])
    # Validate location
    return false unless params[:location].is_a?(String) && !params[:location].empty?
    # Validate interests
    return false unless params[:interests].is_a?(Array) && params[:interests].all? { |i| i.is_a?(Integer) }
    # Validate answers
    if params[:answers].is_a?(Array)
      params[:answers].all? do |answer|
        answer.is_a?(Hash) &&
        answer.key?('question_id') && answer['question_id'].is_a?(Integer) &&
        answer.key?('content') && answer['content'].is_a?(String)
      end
    else
      return false
    end
    true
  end

  def valid_complete_profile_params?
    valid_update_profile_params? && valid_preferences_params?(params[:preferences])
  end

  def valid_preferences_params?(preferences)
    preferences.is_a?(Hash) &&
    preferences.key?('age_range') && preferences['age_range'].is_a?(Array) && preferences['age_range'].size == 2 &&
    preferences['age_range'].all? { |age| age.is_a?(Integer) && age > 0 } &&
    preferences.key?('distance') && preferences['distance'].is_a?(Integer) && preferences['distance'] > 0 &&
    preferences.key?('gender') && preferences['gender'].is_a?(Array) && preferences['gender'].all? { |gender| User.genders.keys.include?(gender) }
  end

  def user_params
    params.require(:user).permit(preferences: {})
  end
end
