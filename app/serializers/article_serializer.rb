class ArticleSerializer
  include JSONAPI::Serializer

  attributes :id, :title, :content, :status, :author_id, :created_at

  # Additional formatting and methods can be added here if needed
end
