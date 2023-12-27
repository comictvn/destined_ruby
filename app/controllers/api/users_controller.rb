class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update_preferences update_profile matches generate_matches]
  before_action :authenticate_user, only: [:matches, :update_preferences, :update_profile, :generate_matches] # Ensure user is authenticated for these actions
  before_action :set_user, only: [:update_preferences, :update_profile, :matches, :generate_matches]

  def index
    # ... existing index action ...
  end

  def matches
    begin
      # Validate that the user ID exists in the database
      raise ActiveRecord::RecordNotFound unless @user.present?

      # Assuming MatchService exists and has a method to find potential matches
      potential_matches = MatchService.find_potential_matches(@user)
      formatted_matches = potential_matches.map do |match|
        {
          id: match.id,
          age: match.age,
          gender: match.gender,
          location: match.location,
          compatibility_score: match.compatibility_score # Assuming compatibility_score is a method or attribute on the match object
        }
      end
      render json: { status: 200, matches: formatted_matches }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found.' }, status: :not_found
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  # ... rest of the controller ...

  private

  def set_user
    @user = User.find_by(id: params[:id])
    render json: { error: 'User not found.' }, status: :not_found unless @user
  end

  # ... rest of the private methods ...
end
