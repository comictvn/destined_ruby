class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :created_at
end
