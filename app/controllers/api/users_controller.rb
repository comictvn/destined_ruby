class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update_profile matches update_preferences complete_profile swipes]
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
    # ... existing update_profile method ...
  end

  # PUT /api/users/:user_id/preferences
  def update_preferences
    return render json: { error: 'User not found' }, status: :not_found unless @user

    preferences = user_params[:preferences]
    unless preferences.is_a?(Hash) # Assuming preferences should be a Hash, update as needed
      return render json: { error: 'Invalid preferences' }, status: :bad_request
    end

    begin
      user_preference = @user.user_preference || @user.build_user_preference
      user_preference.update!(preferences)
      render json: { status: 200, message: 'Preferences updated successfully', preferences: user_preference }, status: :ok
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

    render json: { status: 200, message: "Profile completed successfully.", user: @user.as_json.merge(updated_at: Time.current) }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages.to_sentence }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  rescue Pundit::NotAuthorizedError
    render json: { error: "Not authorized to complete profile" }, status: :forbidden
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def matches
    # ... existing matches method ...
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

  def user_params
    params.require(:user).permit(:age, :gender, :location, interests: [], preferences: {})
  end

  def valid_complete_profile_params?
    valid_update_profile_params? && valid_preferences_params?(params[:preferences]) && params[:interests].is_a?(Array)
  end

  def valid_update_profile_params?
    params[:age].is_a?(Integer) && params[:age] > 0 &&
    User.genders.keys.include?(params[:gender]) &&
    params[:location].is_a?(String)
  end

  def valid_preferences_params?(preferences)
    preferences.is_a?(Hash) && preferences.keys.all? { |key| %w[age_range distance gender].include?(key) }
  end
end
