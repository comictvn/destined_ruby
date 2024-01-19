class ArticleService
  def retrieve_articles(user_id:)
    articles = Article.where(user_id: user_id)
    articles.map do |article|
      {
        article: article,
        statistics: collect_article_statistics(article)
      }
    end
  end

  def add_tags_to_article(article_id, tags)
    tags.each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name)
      ArticleTag.create!(article_id: article_id, tag_id: tag.id)
    rescue StandardError => e
      Rails.logger.error "Failed to add tag #{tag_name} to article #{article_id}: #{e.message}"
    end
    "Tags successfully added to the article."
  end

  private

  def collect_article_statistics(article)
    # Placeholder for statistics collection logic
    # This should be replaced with actual code to collect statistics
    { views: 0, comments: 0 }
  end
end
