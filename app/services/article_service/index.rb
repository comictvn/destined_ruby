class ArticleService
  def manage_articles(user_id:, status:, page:, limit:)
    return { error: 'User not found' } unless User.exists?(user_id: user_id)

    valid_statuses = %w[draft published archived]
    return { error: 'Invalid status value' } unless valid_statuses.include?(status)
    return { error: 'Invalid page number.' } unless page.is_a?(Integer) && page > 0
    return { error: 'Invalid limit value.' } unless limit.is_a?(Integer) && limit > 0

    articles = Article.where(user_id: user_id, status: status)
    total_pages = (articles.count / limit.to_f).ceil
    paginated_articles = articles.offset((page - 1) * limit).limit(limit)

    {
      articles: paginated_articles.as_json(only: [:id, :title, :content, :status, :author_id, :created_at]),
      total_pages: total_pages,
      limit: limit,
      current_page: page
    }
  end

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
    # Actual code to collect statistics should be implemented here
    { views: 0, comments: 0 }
  end
end
