class V1::MatchesController < ApplicationController
  # Other methods...
  def update_match_status
    begin
      match = Match.find(params[:id])
      match.status = params[:status]
      match.save!
      if params[:status] == 'like'
        reciprocal_match = Match.where(id: params[:match_id], user_id: match.user_id).first
        if reciprocal_match&.status == 'like'
          match.status = 'match'
          match.save!
          MatchMailer.match_notification(match.user, reciprocal_match.user).deliver_now
        end
      end
      render json: { status: match.status, message: 'Match status updated successfully' }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: 'Match not found.' }, status: :not_found
    rescue => e
      render json: { error: 'Unexpected error occurred' }, status: :internal_server_error
    end
  end
end
