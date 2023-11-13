if @error.present?

  json.error @error

  json.error_description @error_description

else

  json.access_token @access_token

  json.token_type @token_type

  json.expires_in @expires_in

  json.refresh_token @refresh_token

  json.scope @scope

  json.created_at @created_at

  json.resource_owner @resource_owner

  json.resource_id @resource_id

  json.refresh_token_expires_in @refresh_token_expires_in

end
