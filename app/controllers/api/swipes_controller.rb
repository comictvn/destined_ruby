# FILE PATH: /app/controllers/api/swipes_controller.rb
class Api::SwipesController < Api::BaseController
  before_action :doorkeeper_authorize!
  before_action :validate_swipe_direction, only: [:create]
  before_action :find_users, only: [:create]

  def create
    swipe_service = SwipeService.new
    swipe_result = swipe_service.record_swipe(@swiping_user.id, @swiped_user.id, @direction)

    if swipe_result[:swipe_recorded]
      # Check for mutual interest
      mutual_interest = swipe_service.check_mutual_interest(@swiping_user.id, @swiped_user.id)
      match_created = false

      if mutual_interest
        # Assuming MatchService::Create exists and handles match logic
        match_service = MatchService.new
        match_result = match_service.create_match(@swiping_user.id, @swiped_user.id)

        if match_result[:match_created]
          match_created = true
        else
          render json: { errors: match_result[:errors] || ["Failed to create match."] }, status: :unprocessable_entity and return
        end
      end

      render json: { status: 201, message: "Swipe action recorded successfully.", swipe_recorded: true, match_created: match_created }, status: :created
    else
      render json: { errors: swipe_result[:errors] || ["Failed to record swipe."] }, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def find_users
    # The swiping user is the resource owner of the doorkeeper token
    @swiping_user = User.find_by(id: doorkeeper_token.resource_owner_id)
    @swiped_user = User.find_by(id: swipe_params[:swiped_id])
    unless @swiping_user && @swiped_user
      render json: { error: "User not found." }, status: :not_found and return
    end
  end

  def validate_swipe_direction
    @direction = swipe_params[:direction]
    unless ['right', 'left'].include?(@direction)
      render json: { error: "Invalid swipe direction." }, status: :bad_request and return
    end
  end

  def swipe_params
    params.permit(:swiped_id, :direction)
  end
end
