# PATH: /app/controllers/api/feedbacks_controller.rb
class Api::FeedbacksController < ApplicationController
  include AuthenticationConcern

  before_action :authenticate_user!

  def create
    feedback_params = feedback_params()

    # Verify that the match_id exists in the "matches" table.
    match = Match.find_by(id: feedback_params[:match_id])
    unless match
      render json: { error: 'Match not found.' }, status: :not_found
      return
    end

    # Verify that the user_id exists in the "users" table.
    user = User.find_by(id: feedback_params[:user_id])
    unless user
      render json: { error: 'User not found.' }, status: :not_found
      return
    end

    # Verify that user_id is one of the users involved in the match
    if match.matcher1_id != user.id && match.matcher2_id != user.id
      render json: { error: 'Invalid match_id or user_id' }, status: :unprocessable_entity
      return
    end

    # Validate the rating
    unless feedback_params[:rating].to_f.between?(1.0, 5.0)
      render json: { error: 'Invalid rating.' }, status: :unprocessable_entity
      return
    end

    # Create a new entry in the feedback table
    feedback = Feedback.new(feedback_params)

    if feedback.save
      # Adjust the matching algorithm here if necessary
      # ...

      render json: { status: 201, message: 'Feedback submitted successfully.' }, status: :created
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
