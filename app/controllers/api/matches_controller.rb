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
          content: feedback_params[:comment],
          rating: feedback_params[:rating]
        )
        MatchService.new.adjust_matching_algorithm(feedback)
      end
      render json: { message: 'Feedback submitted successfully' }, status: :created
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  private

  def match_params
    params.require(:match).permit(:user_id, :matched_user_id)
  end
end
