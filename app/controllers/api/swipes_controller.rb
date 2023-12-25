# FILE PATH: /app/controllers/api/swipes_controller.rb
class Api::SwipesController < Api::BaseController
  before_action :doorkeeper_authorize!
  before_action :validate_swipe_direction, only: [:create]
  before_action :find_users, only: [:create]

  def create
    # Assuming SwipeService::Create exists and handles swipe logic
    swipe = SwipeService::Create.new(@swiping_user, @swiped_user, @direction).execute

    if swipe.persisted?
      render json: { status: 201, message: "Swipe recorded successfully." }, status: :created
    else
      render json: { errors: swipe.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def find_users
    @swiping_user = User.find_by(id: params[:id])
    @swiped_user = User.find_by(id: swipe_params[:swiped_id])
    unless @swiping_user && @swiped_user
      render json: { error: "User not found." }, status: :not_found
    end
  end

  def validate_swipe_direction
    @direction = swipe_params[:direction]
    unless ['right', 'left'].include?(@direction)
      render json: { error: "Invalid swipe direction." }, status: :bad_request
    end
  end

  def swipe_params
    params.require(:swipe).permit(:swiped_id, :direction)
  end
end
