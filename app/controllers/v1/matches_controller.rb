class V1::MatchesController < ApplicationController
  before_action :authenticate_user, only: [:update_status]
  def update_status
    begin
      match = Match.find(params[:match_id])
      user = User.find(params[:id])
      status = params[:status]
      MatchesService.update_status(match, user, status)
      if status == "like" && match.user.liked?(user)
        NotificationsService.create_notification(user, match.user, "You have a new match!")
        NotificationsService.create_notification(match.user, user, "You have a new match!")
      end
      render json: { message: 'Match status updated successfully', match_status: match.reload.status }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: 'Match or User not found.' }, status: :not_found
    rescue => e
      render json: { error: 'Unexpected error occurred' }, status: :internal_server_error
    end
  end
  private
  def authenticate_user
    user = User.find_by(session_token: request.headers['Authorization'])
    render json: { error: 'Not Authorized' }, status: :unauthorized unless user
  end
end
