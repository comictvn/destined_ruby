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

    # Use MatchService to create a match
    match_service = MatchService.new
    result = match_service.create_match(match_params[:user_id], match_params[:matched_user_id])

    if result[:success]
      # Ensure the response includes the match details as per the requirement
      match_details = {
        id: result[:match].id,
        user_id: result[:match].user_id,
        matcher1_id: result[:match].user_id,
        matcher2_id: result[:match].matched_user_id,
        created_at: result[:match].created_at.iso8601
      }
      render json: { status: 201, message: "Match recorded successfully.", match: match_details }, status: :created
    else
      render json: { error: result[:message] }, status: (result[:error] ? :internal_server_error : :conflict)
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :bad_request
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # ... rest of the existing create_feedback and record_swipe methods ...

  private

  # ... rest of the existing private methods ...
end
