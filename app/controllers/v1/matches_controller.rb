class V1::MatchesController < ApplicationController
  # Other methods...
  def update_match_status
    begin
      user_id = params[:id]
      matched_user_id = params[:matched_user_id]
      status = params[:status]
      MatchesService.new.update_match_status(user_id, matched_user_id, status)
      if status == 'like'
        if MatchesService.new.check_mutual_like(user_id, matched_user_id)
          MatchesService.new.update_match_status(user_id, matched_user_id, 'match')
          UserMailer.match_notification(user_id, matched_user_id).deliver_now
          UserMailer.match_notification(matched_user_id, user_id).deliver_now
        end
      end
      render json: { status: 200, message: 'Match status updated successfully' }, status: :ok
    rescue => e
      render json: { error: 'Unexpected error occurred' }, status: :internal_server_error
    end
  end
end
