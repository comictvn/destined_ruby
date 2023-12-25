class Api::MatchFeedbacksController < ApplicationController
  before_action :authorize_request

  def create
    match_id = params[:match_id]
    user_id = params[:user_id]
    feedback_text = params[:feedback_text]

    # Validate the existence of match_id and user_id
    begin
      match = Match.find(match_id)
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Match not found.' }, status: :not_found
      return
    end

    begin
      user = User.find(user_id)
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found.' }, status: :not_found
      return
    end

    # Validate that feedback_text is a string
    unless feedback_text.is_a?(String)
      render json: { error: 'Invalid feedback.' }, status: :unprocessable_entity
      return
    end

    # Authorize the action using MatchFeedbackPolicy
    authorize MatchFeedbackPolicy.new(@current_user, match)

    # Create a new instance of MatchFeedback
    feedback = MatchFeedback.new(match_id: match_id, user_id: user_id, feedback_text: feedback_text)

    if feedback.save
      # Serialize the feedback data
      serialized_feedback = MatchFeedbackSerializer.new(feedback).as_json
      render json: { status: 201, feedback: serialized_feedback }, status: :created
    else
      render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
    end
  rescue Pundit::NotAuthorizedError
    render json: { error: 'User not authorized to give feedback on this match' }, status: :forbidden
  end
end
