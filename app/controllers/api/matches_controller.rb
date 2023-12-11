class Api::MatchesController < ApplicationController
  include AuthenticationConcern

  before_action :authenticate_user!

  def create
    match_params = params.require(:match).permit(:user_id, :matched_user_id)

    # Validate user IDs
    unless User.exists?(match_params[:user_id]) && User.exists?(match_params[:matched_user_id])
      return render json: { error: "User not found." }, status: :bad_request
    end

    # Check if match already exists
    if Match.exists?(user_id: match_params[:user_id], matched_user_id: match_params[:matched_user_id]) ||
       Match.exists?(user_id: match_params[:matched_user_id], matched_user_id: match_params[:user_id])
      return render json: { error: "Match already exists." }, status: :conflict
    end

    match = Match.create(user_id: match_params[:user_id], matched_user_id: match_params[:matched_user_id])
    if match.persisted?
      render json: { status: 201, message: "Match recorded successfully." }, status: :created
    else
      render json: { error: "Internal server error." }, status: :internal_server_error
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :bad_request
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def create_feedback
    match_id = params[:match_id]
    feedback_params = params.require(:feedback).permit(:user_id, :feedback_text)

    # Validate match existence
    match = Match.find_by(id: match_id)
    return render json: { error: 'Match not found' }, status: :not_found unless match

    # Validate user existence and part of the match
    unless User.exists?(feedback_params[:user_id]) && match.users.exists?(id: feedback_params[:user_id])
      return render json: { error: 'Invalid user' }, status: :forbidden
    end

    # Validate feedback text
    unless feedback_params[:feedback_text].is_a?(String)
      return render json: { error: 'Invalid feedback' }, status: :unprocessable_entity
    end

    # Create feedback
    feedback = Feedback.create!(
      match_id: match_id,
      user_id: feedback_params[:user_id],
      content: feedback_params[:feedback_text]
    )

    if feedback.persisted?
      render json: { status: 201, message: 'Feedback submitted successfully' }, status: :created
    else
      render json: { error: 'Internal server error' }, status: :internal_server_error
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # Other actions...

  private

  def feedback_params
    params.require(:feedback).permit(:user_id, :feedback_text)
  end

  # Other private methods...
end
