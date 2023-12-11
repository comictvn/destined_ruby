class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update_profile matches update_preferences complete_profile]
  before_action :set_user, only: [:matches, :update_preferences, :complete_profile]

  # ... existing methods ...

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

  private

  # ... existing private methods ...

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
end
