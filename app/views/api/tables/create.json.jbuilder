json.status 200
json.table do
  json.id @table.id
  json.name @table.name
  json.created_at @table.created_at
end
