module ArticleService
  class Publish
    def publish(article_id:, status:)
      raise ArgumentError, 'Article ID cannot be nil or empty' if article_id.nil? || article_id.empty?

      raise ArgumentError, "Only 'published' status is allowed" unless status == 'published'

      article = Article.find(article_id)
      article.update!(status: 'published')

      "Article ##{article_id} has been published."
    rescue ActiveRecord::RecordNotFound => e
      raise e.message
    rescue ActiveRecord::RecordInvalid => e
      raise e.message
    end
  end
end
