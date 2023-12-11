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
    feedback_params = params.require(:feedback).permit(:user_id, :feedback_text, :comment, :rating)

    # Validate match existence
    match = Match.find_by(id: match_id)
    return render json: { error: 'Match not found' }, status: :not_found unless match

    # Validate user existence and part of the match
    unless User.exists?(feedback_params[:user_id]) && match.users.exists?(id: feedback_params[:user_id])
      return render json: { error: 'Invalid user' }, status: :forbidden
    end

    # Validate feedback text or comment
    content = feedback_params[:feedback_text] || feedback_params[:comment]
    unless content.is_a?(String)
      return render json: { error: 'Invalid feedback' }, status: :unprocessable_entity
    end

    # Validate rating if present
    if feedback_params[:rating].present?
      unless feedback_params[:rating].is_a?(Integer) && feedback_params[:rating].between?(1, 5)
        return render json: { error: 'Rating must be an integer between 1 and 5' }, status: :unprocessable_entity
      end
    end

    # Create feedback
    feedback = Feedback.create!(
      match_id: match_id,
      user_id: feedback_params[:user_id],
      content: content,
      rating: feedback_params[:rating] # This line is only needed if the rating is present
    )

    if feedback.persisted?
      MatchService.new.adjust_matching_algorithm(feedback) if feedback_params[:rating].present?
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

  def record_swipe
    swipe_params = params.require(:swipe).permit(:user_id, :target_user_id, :swipe_direction)

    # Validate the existence of both users
    unless User.exists?(swipe_params[:user_id]) && User.exists?(swipe_params[:target_user_id])
      return render json: { error: "User not found." }, status: :not_found
    end

    # Validate swipe direction
    unless ['right', 'left'].include?(swipe_params[:swipe_direction])
      return render json: { error: "Invalid swipe direction." }, status: :bad_request
    end

    # Check for an existing opposite swipe
    if swipe_params[:swipe_direction] == 'right' && opposite_swipe_exists?(swipe_params[:target_user_id], swipe_params[:user_id])
      # Create a new match
      match = Match.create(user_id: swipe_params[:user_id], matched_user_id: swipe_params[:target_user_id])
      if match.persisted?
        render json: { message: "It's a match!", match_id: match.id }, status: :created
      else
        render json: { error: "Could not create match." }, status: :internal_server_error
      end
    else
      # Log or store the one-sided swipe action
      Swipe.create!(user_id: swipe_params[:user_id], target_user_id: swipe_params[:target_user_id], swipe_direction: swipe_params[:swipe_direction])
      render json: { message: "Swipe recorded." }, status: :ok
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

  # Other private methods...
end
