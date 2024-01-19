module ArticleService
  class Index
    def add_tags_to_article(article_id, tags)
      tags.each do |tag_name|
        tag = Tag.find_or_create_by(name: tag_name)
        ArticleTag.create!(article_id: article_id, tag_id: tag.id)
      rescue StandardError => e
        Rails.logger.error "Failed to add tag #{tag_name} to article #{article_id}: #{e.message}"
      end
      "Tags successfully added to the article."
    end
  end
end
