json.shop do
  json.id @shop.id
  json.name @shop.name
  json.address @shop.address
  json.updated_at @shop.updated_at
end
if @shop.errors.any?
  json.status 'error'
  json.code 400
  json.message 'Update operation failed'
  json.errors @shop.errors
else
  json.status 'success'
  json.code 200
  json.message 'Update operation successful'
end
