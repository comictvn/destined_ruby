class MessageSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at, :updated_at
end