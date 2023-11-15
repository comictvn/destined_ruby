json.status 200
json.user do
  json.id @user.id
  json.name @user.name
  json.status @user.status
  json.created_at @user.created_at
  json.updated_at @user.updated_at
end
