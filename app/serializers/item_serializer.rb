class ItemSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :price, :discounted_price, :collection_name

  attribute :collection_name do |object|
    object.collection.name
  end

  attribute :discounted_price do |object|
    object.discounted_price if object.discounted_price.present?
  end
end