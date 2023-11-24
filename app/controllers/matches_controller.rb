class MatchesController < ApplicationController
  # Other methods...
  def check_match_status
    begin
      id = params[:id]
      match_user_id = params[:match_user_id]
      match_status = MatchService.new.check_match_status(id, match_user_id)
      render json: { match_status: match_status, match_user_id: match_user_id }, status: :ok
    rescue => e
      render json: { error: 'Unexpected error occurred' }, status: :internal_server_error
    end
  end
end
