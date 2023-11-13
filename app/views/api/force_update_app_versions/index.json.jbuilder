if @message.present?

  json.message @message

else

  json.total_pages @total_pages

  json.force_update_app_versions @force_update_app_versions do |force_update_app_version|
    json.id force_update_app_version.id

    json.created_at force_update_app_version.created_at

    json.updated_at force_update_app_version.updated_at

    json.platform force_update_app_version.platform

    json.reason force_update_app_version.reason

    json.version force_update_app_version.version

    json.force_update force_update_app_version.force_update
  end

end
