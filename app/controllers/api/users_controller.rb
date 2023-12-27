class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update_preferences update_profile matches generate_matches generate_potential_matches complete_profile]
  before_action :authenticate_user, only: [:matches, :update_preferences, :update_profile, :generate_matches, :generate_potential_matches, :complete_profile] # Ensure user is authenticated for these actions
  before_action :set_user, only: [:update_preferences, :update_profile, :matches, :generate_matches, :generate_potential_matches, :complete_profile]

  def index
    # ... existing index action ...
  end

  def matches
    # ... existing matches action ...
  end

  def update_preferences
    begin
      # Ensure the user is found
      raise ActiveRecord::RecordNotFound unless @user.present?

      # Validate the preferences JSON object
      validated_preferences = PreferencesValidator.validate!(preferences_params)
      raise ArgumentError, 'Invalid preferences.' unless validated_preferences

      # Update the user's preferences using a service or directly if service not available
      if defined?(PreferencesService) && PreferencesService.respond_to?(:update_user_preferences)
        update_success = PreferencesService.update_user_preferences(@user, validated_preferences)
      else
        @user.preferences.update!(validated_preferences)
        update_success = true
      end

      # Update the "updated_at" timestamp in the "preferences" table to reflect the changes.
      @user.touch(:preferences_updated_at)

      # Ensure the matching algorithm takes these updates into account when suggesting future matches.
      # This is assumed to be handled by the MatchService when it is called next time.

      if update_success
        # Return success response
        render json: {
          status: 200,
          message: 'Preferences updated successfully.',
          preferences: @user.preferences
        }, status: :ok
      else
        render json: { error: 'Unable to update preferences.' }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found.' }, status: :not_found
    rescue ArgumentError => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def update_profile
    # ... existing update_profile action ...
  end

  def generate_matches
    # ... existing generate_matches action ...
  end

  def generate_potential_matches
    begin
      # Ensure user is loaded and exists
      raise ActiveRecord::RecordNotFound unless @user.present?

      # Instantiate the MatchService and generate potential matches
      match_service = MatchService.new(@user.id)
      potential_matches = match_service.generate_potential_matches

      # Format the matches for the response
      formatted_matches = potential_matches.map do |match|
        {
          id: match[:user].id,
          age: match[:user].age,
          gender: match[:user].gender,
          location: match[:user].location,
          compatibility_score: match[:score]
        }
      end

      # Render the successful response
      render json: { status: 200, matches: formatted_matches }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found.' }, status: :not_found
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def complete_profile
    if validate_user_profile_params
      user_profile_service = UserProfileService.new(
        @user,
        user_profile_params[:age],
        user_profile_params[:gender],
        user_profile_params[:location],
        user_profile_params[:interests],
        user_profile_params[:preferences]
      )

      result = user_profile_service.update_user_profile

      if result[:success]
        render json: { status: 200, message: 'Profile updated successfully.', user: result[:user].as_json(include: [:preferences]) }, status: :ok
      else
        render json: { status: 422, message: result[:error][:message] }, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found.' }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # ... rest of the controller ...

  private

  def set_user
    @user = User.find_by(id: params[:id])
    render json: { error: 'User not found.' }, status: :not_found unless @user
  end

  def user_profile_params
    params.require(:user).permit(:age, :gender, :location, interests: [], preferences: {})
  end

  def validate_user_profile_params
    # ... existing validation logic ...
  end

  def preferences_params
    params.require(:preferences).permit(:age_range => [], :distance, :gender => [])
  end

  # ... rest of the private methods ...
end
