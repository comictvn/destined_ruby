class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update_profile matches update_preferences complete_profile swipes record_swipe get_potential_matches]
  before_action :set_user, only: [:matches, :update_preferences, :complete_profile, :record_swipe, :get_potential_matches]
  before_action :authenticate_user!, only: [:update_preferences, :update_profile, :record_swipe, :get_potential_matches] # authenticate_user! is now used for :record_swipe and :get_potential_matches as well
  before_action :validate_preferences, only: [:update_preferences]
  before_action :validate_swipe_action, only: [:record_swipe]

  require_dependency 'matchmaking_service'
  require_dependency 'user_service/update_profile'
  require_dependency 'user_preference_service'

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

  def update_profile
    # ... existing update_profile method ...
  end

  def update_preferences
    # ... existing update_preferences method ...
  end

  def complete_profile
    # ... existing complete_profile method ...
  end

  def matches
    # ... existing matches method ...
  end

  def record_swipe
    # ... existing record_swipe method ...
  end

  # GET /api/users/:user_id/matches
  def get_potential_matches
    return render json: { error: 'User not found' }, status: :not_found unless @user

    begin
      potential_matches = MatchmakingService.new.generate_potential_matches(@user.id)
      render json: { status: 200, matches: potential_matches }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found' }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  private

  # ... existing private methods ...

  def authenticate_user!
    # ... existing authenticate_user! method ...
  end

  def validate_preferences
    # ... existing validate_preferences method ...
  end

  def set_user_by_id
    # ... existing set_user_by_id method ...
  end

  def valid_update_profile_params?
    # ... existing valid_update_profile_params? method ...
  end

  def valid_interests_params?(interests)
    # ... existing valid_interests_params? method ...
  end

  def valid_preferences_params?(preferences)
    # ... existing valid_preferences_params? method ...
  end

  def set_user
    @user = User.find_by(id: params[:user_id] || params[:id])
    unless @user
      render json: { error: 'User not found' }, status: :not_found and return
    end
  end

  def swipe_params
    # ... existing swipe_params method ...
  end

  def validate_swipe_action
    # ... existing validate_swipe_action method ...
  end

  def valid_complete_profile_params?
    # ... existing valid_complete_profile_params? method ...
  end

  # ... rest of the file ...
end
