json.total @users.count
json.users @users do |user|
  json.id user.id
  json.name user.name
  json.email user.email
  json.created_at user.created_at
  json.updated_at user.updated_at
  json.phone_number user.phone_number
  json.firstname user.firstname
  json.lastname user.lastname
  json.dob user.dob
  json.gender user.gender
  json.interests user.interests
  json.location user.location
  json.email user.email
end
