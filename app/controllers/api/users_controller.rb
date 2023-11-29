class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update_profile generate_matches swipe]
  before_action :set_user, only: %i[show update_profile generate_matches swipe]
  before_action :authorize_user, only: %i[show update_profile generate_matches swipe]
  def index
    @users = UserService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @users.total_pages
  end
  def show
  end
  def update_profile
    if @user.update(user_params)
      render json: {success: true, message: 'Profile updated successfully'}
    else
      render json: {success: false, message: @user.errors.full_messages.join(', ')}
    end
  end
  def generate_matches
    @matches = UserService::GenerateMatches.new(params[:id]).execute
    render json: { matches: @matches }, status: :ok
  end
  def swipe
    swipe_direction = params[:swipe_direction]
    return render json: { error: 'Invalid swipe direction' }, status: :bad_request unless ['right', 'left'].include?(swipe_direction)
    if swipe_direction == 'right'
      is_matched = UserService::CheckMatch.new(params[:id], params[:matched_user_id]).execute
      if is_matched
        Match.create_match(params[:id], params[:matched_user_id])
        TwilioGateway.send_notification(params[:id], params[:matched_user_id])
        render json: { status: 'Matched' }, status: :ok
      else
        render json: { status: 'Not Matched' }, status: :ok
      end
    else
      render json: { status: 'Not Matched' }, status: :ok
    end
  end
  private
  def set_user
    @user = User.find_by!('users.id = ?', params[:id])
  end
  def authorize_user
    authorize @user, policy_class: Api::UsersPolicy
  end
  def user_params
    params.permit(:age, :gender, :location, :interests, :preferences)
  end
end
