class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update_preferences update_profile]
  before_action :authenticate_user, only: [:matches]
  before_action :set_user, only: [:update_preferences, :update_profile]

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

  # ... rest of the code remains unchanged ...

  private

  # ... rest of the private methods remains unchanged ...

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
