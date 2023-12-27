class Api::MatchFeedbacksController < ApplicationController
  before_action :authorize_request

  def create
    match_id = params.require(:match_id)
    user_id = params.require(:user_id)
    feedback_text = params.require(:feedback_text)

    # Validate the existence of match_id and user_id
    begin
      match = Match.find(match_id)
      user = User.find(user_id)
    rescue ActiveRecord::RecordNotFound => e
      message = e.model == 'Match' ? 'Match not found.' : 'User not found.'
      render json: { error: message }, status: :not_found
      return
    end

    # Validate that feedback_text is a string
    unless feedback_text.is_a?(String)
      render json: { error: 'Invalid feedback.' }, status: :unprocessable_entity
      return
    end

    # Validate that the user is involved in the match
    unless [match.matcher1_id, match.matcher2_id].include?(user_id.to_i)
      render json: { error: 'User not involved in the match.' }, status: :forbidden
      return
    end

    # Authorize the action using MatchFeedbackPolicy
    authorize MatchFeedbackPolicy.new(@current_user, match)

    # Instantiate MatchFeedbackService and call create_feedback
    begin
      feedback_service = MatchFeedbackService.new
      feedback = feedback_service.create_feedback(match_id, user_id, feedback_text)
      render json: { status: 201, feedback: feedback }, status: :created
    rescue Exceptions::BadRequest => e
      render json: { error: e.message }, status: :bad_request
    rescue Pundit::NotAuthorizedError
      render json: { error: 'User not authorized to give feedback on this match' }, status: :forbidden
    end
  end
end
