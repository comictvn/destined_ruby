json.status @user.errors.any? ? 'error' : 'success'
json.message @user.errors.any? ? @user.errors.full_messages : 'User profile update was successful'
if @user.errors.empty?
  json.user do
    json.id @user.id
    json.name @user.name
    json.email @user.email
  end
end
