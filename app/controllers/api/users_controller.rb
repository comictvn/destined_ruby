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
    # ... existing update_profile method ...
  end

  # PUT /api/users/:user_id/preferences
  def update_preferences
    # ... existing update_preferences method ...
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

    render json: { status: 200, message: "Profile completed successfully." }, status: :ok
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

  private

  # ... existing private methods ...

  def valid_complete_profile_params?
    valid_update_profile_params? && valid_preferences_params?(params[:preferences]) && params[:interests].is_a?(Array)
  end
end
