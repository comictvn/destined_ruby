class MatchFeedbacksController < ApplicationController
  before_action :authorize_request

  def create_feedback
    match_id = params[:match_id]
    user_id = params[:user_id]
    feedback_text = params[:feedback_text]

    # Validate the input data
    validator = MatchFeedbackValidator.new(match_id: match_id, user_id: user_id)
    unless validator.valid?
      render json: { errors: validator.errors.full_messages }, status: :unprocessable_entity
      return
    end

    # Authorize the action
    match = Match.find(match_id)
    unless match.users.exists?(user_id)
      render json: { error: 'User not involved in the match' }, status: :forbidden
      return
    end
    authorize MatchFeedbackPolicy.new(@current_user, match)

    # Create the feedback
    feedback = MatchFeedback.new(match_id: match_id, user_id: user_id, feedback_text: feedback_text, created_at: Time.now)

    if feedback.save
      # Serialize the feedback data
      serialized_feedback = MatchFeedbackSerializer.new(feedback).as_json
      render json: { status: 'success', feedback: serialized_feedback }, status: :created
    else
      render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Match not found' }, status: :not_found
  rescue Pundit::NotAuthorizedError
    render json: { error: 'User not authorized to give feedback on this match' }, status: :forbidden
  end

  private

  # Add any additional methods you need here

end
