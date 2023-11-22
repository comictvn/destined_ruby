class NotificationsService
  def initialize(user_id, page = 1, per_page = 10)
    @user_id = user_id
    @page = page
    @per_page = per_page
  end
  def get_notifications
    validate_user
    notifications = Notification.where(user_id: @user_id).order(created_at: :desc)
    total_notifications = notifications.count
    notifications = notifications.paginate(page: @page, per_page: @per_page)
    total_pages = notifications.total_pages
    { notifications: notifications, total_notifications: total_notifications, total_pages: total_pages }
  end
  private
  def validate_user
    user = User.find_by(id: @user_id)
    raise 'User not found' unless user
    raise 'User not logged in' unless user.logged_in?
  end
end
