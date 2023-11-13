if @error_object.present?

  json.error_object @error_object

else

  json.user do
    json.id @user.id

    json.created_at @user.created_at

    json.updated_at @user.updated_at

    json.phone_number @user.phone_number

    json.thumbnail @user.thumbnail

    json.firstname @user.firstname

    json.lastname @user.lastname

    json.dob @user.dob

    json.gender @user.gender

    json.interests @user.interests

    json.location @user.location

    json.email @user.email
  end

end
