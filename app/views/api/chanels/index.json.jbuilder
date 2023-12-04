json.total_items @chanels.count
json.chanels @chanels do |chanel|
  json.id chanel.id
  json.name chanel.name
  json.description chanel.description
  json.created_at chanel.created_at
  json.updated_at chanel.updated_at
end
