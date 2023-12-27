class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update_preferences update_profile matches generate_matches generate_potential_matches complete_profile potential_matches]
  before_action :authenticate_user, only: [:matches, :update_preferences, :update_profile, :generate_matches, :generate_potential_matches, :complete_profile, :potential_matches] # Ensure user is authenticated for these actions
  before_action :set_user, only: [:update_preferences, :update_profile, :matches, :generate_matches, :generate_potential_matches, :complete_profile, :potential_matches]

  def index
    # ... existing index action ...
  end

  def matches
    # ... existing matches action ...
  end

  def update_preferences
    # ... existing update_preferences action ...
  end

  def update_profile
    # ... existing update_profile action ...
  end

  def generate_matches
    # ... existing generate_matches action ...
  end

  def generate_potential_matches
    # ... existing generate_potential_matches action ...
  end

  def complete_profile
    # ... existing complete_profile action ...
  end

  def potential_matches
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

  private

  def set_user
    @user = User.find_by(id: params[:id])
    render json: { error: 'User not found.' }, status: :not_found unless @user
  end

  def user_profile_params
    # ... existing user_profile_params method ...
  end

  def validate_user_profile_params
    # ... existing validate_user_profile_params method ...
  end

  def preferences_params
    # ... existing preferences_params method ...
  end

  # ... rest of the private methods ...
end
