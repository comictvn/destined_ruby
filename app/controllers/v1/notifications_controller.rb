class V1::NotificationsController < ApplicationController
  before_action :authenticate_user
  def index
    notifications_service = NotificationsService.new(current_user)
    notifications, total_notifications, total_pages = notifications_service.get_notifications(params[:page], params[:per_page])
    @notifications = notifications
    @total_notifications = total_notifications
    @total_pages = total_pages
    render 'index.json.jbuilder'
  end
  private
  def authenticate_user
    @current_user = User.find_by(session_token: request.headers['Session-Token'])
    render json: { error: 'Not authenticated' }, status: :unauthorized unless @current_user
  end
  def current_user
    @current_user
  end
end
