# FILE PATH: /app/controllers/api/swipes_controller.rb
class Api::SwipesController < Api::BaseController
  before_action :doorkeeper_authorize!
  before_action :validate_swipe_direction, only: [:create]
  before_action :find_users, only: [:create]

  def create
    # Assuming SwipeService::Create exists and handles swipe logic
    swipe_service = SwipeService.new
    swipe_result = swipe_service.record_swipe(@swiping_user.id, @swiped_user.id, @direction)

    if swipe_result[:swipe_recorded]
      render json: { status: 201, message: "Swipe recorded successfully." }, status: :created
    else
      render json: { errors: swipe_result[:errors] || ["Failed to record swipe."] }, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def find_users
    @swiping_user = User.find_by(id: params[:id])
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
    params.require(:swipe).permit(:swiped_id, :direction)
  end
end
