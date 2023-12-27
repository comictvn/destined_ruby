class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update_preferences update_profile matches]
  before_action :authenticate_user, only: [:matches, :update_preferences] # Added :update_preferences to ensure user is authenticated
  before_action :set_user, only: [:update_preferences, :update_profile, :matches]

  def index
    # ... existing index action ...
  end

  def matches
    begin
      # Validate that the user ID exists in the database
      raise ActiveRecord::RecordNotFound unless @user.present?

      # Assuming MatchService exists and has a method to find potential matches
      # Update: Using MatchService instead of PreferencesService to find potential matches
      potential_matches = MatchService.find_potential_matches(@user)
      render json: { status: 200, matches: potential_matches }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found.' }, status: :not_found
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def update_preferences
    # ... existing update_preferences action ...
  end

  def update_profile
    # ... existing update_profile action ...
  end

  # ... rest of the controller ...

  private

  def set_user
    @user = User.find_by(id: params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  # ... rest of the private methods ...
end
