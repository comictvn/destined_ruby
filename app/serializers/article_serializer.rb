class ArticleSerializer
  include JSONAPI::Serializer

  attributes :title, :content, :status

  # Additional formatting and methods can be added here if needed
end
