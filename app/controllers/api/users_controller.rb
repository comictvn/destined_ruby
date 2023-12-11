class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update_profile matches]
  before_action :set_user, only: [:matches]

  def index
    # inside service params are checked and whitelisted
    @users = UserService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @users.total_pages
  end

  def show
    @user = User.find_by!('users.id = ?', params[:id])
    authorize @user, policy_class: Api::UsersPolicy
  end

  # PUT /api/users/:id/profile
  def update_profile
    # Validate the input parameters
    unless valid_update_profile_params?
      render json: { error: "Invalid parameters" }, status: :bad_request
      return
    end

    service = UserService::UpdateProfile.new(
      user_id: params[:id],
      age: params[:age],
      gender: params[:gender],
      location: params[:location],
      interests: params[:interests],
      answers: params[:answers]
    )
    
    result = service.update_profile
    
    if result[:error].present?
      render json: { error: result[:error] }, status: :unprocessable_entity
    else
      render json: { status: 200, message: "Profile updated successfully." }, status: :ok
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  def matches
    return render json: { error: 'User not found.' }, status: :bad_request unless @user

    potential_matches = MatchmakingService.new.generate_potential_matches(@user.id)
    formatted_matches = potential_matches.map do |match|
      {
        id: match[:match].id,
        age: match[:match].age,
        gender: match[:match].gender,
        location: match[:match].location,
        compatibility_score: match[:score]
      }
    end

    render json: { status: 200, matches: formatted_matches }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def doorkeeper_authorize!
    # Implement user authentication logic here, possibly using OAuthTokensConcern
  end

  def set_user
    @user = User.find_by(id: params[:id])
  end

  def valid_update_profile_params?
    # Validate age
    return false unless params[:age].is_a?(Integer) && params[:age] > 0
    # Validate gender
    return false unless User.genders.keys.include?(params[:gender])
    # Validate location
    return false unless params[:location].is_a?(String) && !params[:location].empty?
    # Validate interests
    return false unless params[:interests].is_a?(Array) && params[:interests].all? { |i| i.is_a?(Integer) }
    # Validate answers
    if params[:answers].is_a?(Array)
      params[:answers].all? do |answer|
        answer.is_a?(Hash) &&
        answer.key?('question_id') && answer['question_id'].is_a?(Integer) &&
        answer.key?('content') && answer['content'].is_a?(String)
      end
    else
      return false
    end
    true
  end
end
