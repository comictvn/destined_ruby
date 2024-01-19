json.articles @articles do |article|
  json.id article.id
  json.title article.title
  json.content article.content
  json.status article.status
  json.created_at article.created_at
  json.updated_at article.updated_at
  json.user_id article.user_id
  # Add more fields as required
end
