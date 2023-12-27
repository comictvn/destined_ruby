class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update_preferences update_profile matches]
  before_action :authenticate_user, only: [:matches]
  before_action :set_user, only: [:update_preferences, :update_profile, :matches]

  def index
    begin
      # Apply policy scope based on the current user.
      user_scope = policy_scope(User)

      # Filter and order users
      filtered_users = filter_users(user_scope, params)

      # Paginate the results
      paginated_users = paginate_users(filtered_users, params)

      render json: { records: paginated_users.map(&:as_json), total_pages: paginated_users.total_pages }, status: :ok
    rescue UserService::Index::FilteringError => e
      render json: { error: e.message }, status: :bad_request
    rescue UserService::Index::PaginationError => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def matches
    begin
      # Validate that the user ID exists in the database
      raise ActiveRecord::RecordNotFound unless @user.present?

      # Assuming PreferencesService exists and has a method to find potential matches
      potential_matches = PreferencesService.find_potential_matches(@user)
      render json: { status: 200, matches: potential_matches }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found.' }, status: :not_found
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def update_profile
    if validate_user_profile_params
      user_profile_service = UserProfileService.new(
        @user,
        user_profile_params[:age],
        user_profile_params[:gender],
        user_profile_params[:location],
        user_profile_params[:interests],
        user_profile_params[:preferences],
        user_profile_params[:personality_answers]
      )

      result = user_profile_service.update_user_profile

      if result[:success]
        render json: { status: 200, message: 'Profile updated successfully.', user: result[:user].as_json }, status: :ok
      else
        render json: { status: result[:error][:status], message: result[:error][:message] }, status: result[:error][:status]
      end
    end
  end

  # ... rest of the controller ...

  private

  def set_user
    @user = User.find_by(id: params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  def user_profile_params
    params.require(:user).permit(:age, :gender, :location, interests: [], preferences: {}, personality_answers: [])
  end

  def validate_user_profile_params
    errors = []
    errors << 'Invalid age.' unless user_profile_params[:age].to_i.positive?
    errors << 'Invalid gender.' unless User.genders.keys.include?(user_profile_params[:gender])
    errors << 'Invalid location.' unless user_profile_params[:location].is_a?(String)
    errors << 'Invalid interests.' unless user_profile_params[:interests].is_a?(Array) && user_profile_params[:interests].all? { |i| i.is_a?(String) }
    errors << 'Invalid preferences.' unless user_profile_params[:preferences].is_a?(Hash)

    if errors.any?
      render json: { status: 422, message: errors.join(' ') }, status: :unprocessable_entity
      return false
    end

    true
  end

  def filter_users(scope, params)
    scope = scope.filter_by_phone(params[:phone]) if params[:phone].present?
    scope = scope.filter_by_first_name(params[:first_name]) if params[:first_name].present?
    scope = scope.filter_by_last_name(params[:last_name]) if params[:last_name].present?
    scope = scope.filter_by_date_of_birth(params[:date_of_birth]) if params[:date_of_birth].present?
    scope = scope.filter_by_gender(params[:gender]) if params[:gender].present?
    scope = scope.filter_by_interests(params[:interests]) if params[:interests].present?
    scope = scope.filter_by_location(params[:location]) if params[:location].present?
    scope = scope.filter_by_email(params[:email]) if params[:email].present?
    scope.order(created_at: :desc)
  end

  def paginate_users(scope, params)
    page = params[:page] || 1
    per_page = params[:per_page] || 25
    scope.page(page).per(per_page)
  end
end
