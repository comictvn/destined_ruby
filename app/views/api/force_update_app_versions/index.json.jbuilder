
json.status 200

if @message.present?
  json.message @message
else
  json.force_update_app_versions @force_update_app_versions, :id, :force_update, :version, :reason, :created_at, :updated_at, :platform
  json.total_pages @total_pages if @total_pages.present?
  json.total_items @total_items if @total_items.present?
  json.current_page @current_page if @current_page.present?
  json.per_page @per_page if @per_page.present?
end
