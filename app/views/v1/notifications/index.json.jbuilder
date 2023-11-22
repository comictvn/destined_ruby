json.notifications do
  json.array! @notifications do |notification|
    json.id notification.id
    json.message notification.message
    json.created_at notification.created_at
    json.updated_at notification.updated_at
  end
end
json.total_notifications @total_notifications
json.total_pages @total_pages
