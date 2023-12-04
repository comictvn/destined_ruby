if @error_object.present?
  json.error_object @error_object
else
  json.extract! @message, :id, :content, :created_at, :updated_at
end
