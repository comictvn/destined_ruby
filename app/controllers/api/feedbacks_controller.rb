# PATH: /app/controllers/api/feedbacks_controller.rb
class Api::FeedbacksController < ApplicationController
  include AuthenticationConcern

  before_action :authenticate_user!

  def create
    feedback_params = feedback_params()

    # Verify that the match_id exists and that user_id is one of the users involved in the match
    match = Match.find_by(id: feedback_params[:match_id])
    if match.nil? || (match.user_id != feedback_params[:user_id] && match.opponent_id != feedback_params[:user_id])
      render json: { error: 'Invalid match_id or user_id' }, status: :unprocessable_entity
      return
    end

    # Create a new entry in the feedback table
    feedback = Feedback.new(feedback_params)

    if feedback.save
      # Adjust the matching algorithm here if necessary
      # ...

      render json: { message: 'Feedback submitted successfully', feedback: feedback }, status: :created
    else
      render json: { error: feedback.errors.full_messages }, status: :unprocessable_entity
    end
  rescue Pundit::NotAuthorizedError
    render json: { error: 'You are not authorized to perform this action' }, status: :forbidden
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def feedback_params
    params.require(:feedback).permit(:match_id, :user_id, :comment, :rating)
  end
end
