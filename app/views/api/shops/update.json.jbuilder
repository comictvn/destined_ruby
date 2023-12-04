json.status 200
json.shop do
  json.id @shop.id
  json.name @shop.name
  json.address @shop.address
end
json.message "Shop updated successfully"
