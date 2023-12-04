if @shop.errors.any?
  json.status 400
  json.errors @shop.errors.full_messages
else
  json.status 200
  json.shop do
    json.id @shop.id
    json.name @shop.name
    json.address @shop.address
  end
end
