class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show matches]
  before_action :set_user, only: [:matches]

  def index
    @users = UserService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @users.total_pages
  end

  def show
    @user = User.find_by!('users.id = ?', params[:id])
    authorize @user, policy_class: Api::UsersPolicy
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

  def set_user
    @user = User.find_by(id: params[:id])
  end
end
