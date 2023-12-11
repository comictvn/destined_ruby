class Api::MatchesController < ApplicationController
  include AuthenticationConcern
  include MatchFeedbackService

  before_action :authenticate_user!

  def create
    match_params = params.require(:match).permit(:matcher1_id, :matcher2_id)

    # Validate user IDs
    unless User.exists?(match_params[:matcher1_id]) && User.exists?(match_params[:matcher2_id])
      return render json: { error: "User not found." }, status: :bad_request
    end

    # Check if match already exists
    if Match.exists?(matcher1_id: match_params[:matcher1_id], matcher2_id: match_params[:matcher2_id]) ||
       Match.exists?(matcher1_id: match_params[:matcher2_id], matcher2_id: match_params[:matcher1_id])
      return render json: { error: "Match already exists." }, status: :unprocessable_entity
    end

    result = MatchService.new.record_mutual_interest(match_params[:matcher1_id], match_params[:matcher2_id])
    render json: result[:match], status: result[:status]
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

  def feedback_params
    params.require(:feedback).permit(:user_id, :content, :rating)
  end
end
