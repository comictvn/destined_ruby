class Api::MatchesController < Api::BaseController
  def update_match_status
    match = Match.find_by(id: params[:id], user_id: params[:matched_user_id])
    if match.blank?
      render json: { error_message: 'Match not found' }, status: :not_found
      return
    end
    match.status = params[:status]
    if params[:status] == 'like'
      if Match.where(id: params[:matched_user_id], user_id: params[:id], status: 'like').exists?
        match.status = 'match'
      end
    end
    if match.save
      if match.status == 'match'
        NotificationService.new.send_notification(match.user_id, match.matched_user_id)
      end
      render json: { match_status: match.status, notification_status: match.status == 'match' ? 'sent' : 'not sent' }
    else
      render json: { error_message: match.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
