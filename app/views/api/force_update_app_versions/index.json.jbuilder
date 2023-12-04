json.total_pages @total_pages
json.force_update_app_versions @force_update_app_versions do |force_update_app_version|
  json.version force_update_app_version.version
  json.created_at force_update_app_version.created_at
  json.updated_at force_update_app_version.updated_at
end
