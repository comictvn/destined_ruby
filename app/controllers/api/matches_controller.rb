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
    feedback_params = params.require(:feedback).permit(:user_id, :comment, :rating)

    # Perform validation checks here...
    unless Match.exists?(id: match_id)
      return render json: { error: 'Match not found' }, status: :not_found
    end

    match = Match.find_by(id: match_id)
    unless match.users.exists?(id: feedback_params[:user_id])
      return render json: { error: 'User not part of the match' }, status: :unprocessable_entity
    end

    # Validate rating
    unless feedback_params[:rating].is_a?(Integer) && feedback_params[:rating].between?(1, 5)
      return render json: { error: 'Rating must be an integer between 1 and 5' }, status: :unprocessable_entity
    end

    begin
      ActiveRecord::Base.transaction do
        feedback = Feedback.create!(
          match_id: match_id,
          user_id: feedback_params[:user_id],
          content: feedback_params[:comment] || feedback_params[:feedback_text], # Support both parameter names
          rating: feedback_params[:rating] # This line is only needed if the rating is present
        )
        MatchService.new.adjust_matching_algorithm(feedback) if feedback_params[:rating].present?
      end
      render json: { message: 'Feedback submitted successfully' }, status: :created
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
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

  # New method to handle mutual interest and create a match if it exists
  def create_match_if_mutual_interest
    user_id = params[:user_id]
    matcher1_id = params[:matcher1_id]
    matcher2_id = params[:matcher2_id]

    # Check if there is an existing match entry
    if Match.exists?(user_id: matcher1_id, matched_user_id: matcher2_id) ||
       Match.exists?(user_id: matcher2_id, matched_user_id: matcher1_id)
      return render json: { error: "Match already exists." }, status: :conflict
    end

    begin
      ActiveRecord::Base.transaction do
        # Create a new match entry
        match = Match.create!(user_id: user_id, matched_user_id: matcher1_id, matched_user_id: matcher2_id)
        # Enqueue a job to send a notification to both users
        MatchNotificationJob.perform_later(match.id)
      end
      render json: { message: "Match created successfully.", match: match }, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  private

  def match_params
    params.require(:match).permit(:user_id, :matched_user_id)
  end

  # Helper method to check for an existing opposite swipe
  def opposite_swipe_exists?(target_user_id, user_id)
    Swipe.exists?(user_id: target_user_id, target_user_id: user_id, swipe_direction: 'right')
  end
end
