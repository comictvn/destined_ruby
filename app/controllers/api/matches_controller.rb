# /app/controllers/api/matches_controller.rb

class Api::MatchesController < ApplicationController
  include AuthenticationConcern
  include MatchFeedbackService

  before_action :authenticate_user!

  def create_feedback
    match_id = params[:match_id]
    user_id = feedback_params[:user_id]
    content = feedback_params[:content]

    # Perform validation checks here...
    unless Match.exists?(id: match_id)
      return render json: { error: 'Match not found' }, status: :not_found
    end

    match = Match.find_by(id: match_id)
    unless match.users.exists?(id: user_id)
      return render json: { error: 'User not part of the match' }, status: :unprocessable_entity
    end

    if content.blank?
      return render json: { error: 'Feedback content cannot be empty' }, status: :unprocessable_entity
    end

    begin
      feedback = create_feedback(match_id, user_id, content)
      render json: { status: 201, feedback: feedback.as_json }, status: :created
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:user_id, :content)
  end

  def create_feedback(match_id, user_id, content)
    # Assuming there is a Feedback model with :match_id, :user_id, :content attributes
    Feedback.create!(match_id: match_id, user_id: user_id, content: content)
  end
end
