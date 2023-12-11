# PATH: /app/controllers/api/feedbacks_controller.rb
class Api::FeedbacksController < ApplicationController
  include AuthenticationConcern
  include Pundit

  before_action :authenticate_user!

  def create
    feedback_params = feedback_params()

    # Verify that the match_id exists in the "matches" table.
    match = Match.find_by(id: feedback_params[:match_id])
    unless match
      render json: { error: 'Match not found.' }, status: :not_found
      return
    end

    # Verify that the user_id exists in the "users" table and is part of the match.
    user = User.find_by(id: feedback_params[:user_id])
    unless user && (match.matcher1_id == user.id || match.matcher2_id == user.id)
      render json: { error: 'User not found or not part of the match.' }, status: :not_found
      return
    end

    # Validate the comment
    unless feedback_params[:comment].is_a?(String)
      render json: { error: 'Invalid comment.' }, status: :unprocessable_entity
      return
    end

    # Validate the rating
    unless feedback_params[:rating].to_f.between?(1.0, 5.0)
      render json: { error: 'Invalid rating.' }, status: :unprocessable_entity
      return
    end

    # Authorize the action using FeedbackPolicy
    authorize match, :create_feedback?

    # Create a new entry in the feedback table using FeedbackService::Create
    feedback_service = FeedbackService::Create.new(match_id: feedback_params[:match_id], user_id: feedback_params[:user_id], comment: feedback_params[:comment], rating: feedback_params[:rating])
    result = feedback_service.call

    if result.success?
      render json: { status: 201, message: 'Feedback submitted successfully.' }, status: :created
    else
      render json: { error: result.errors }, status: :unprocessable_entity
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
