module ArticleService
  class Update
    def self.call(article:, title:, content:, status:)
      raise ArgumentError, 'Title cannot be blank' if title.blank?
      raise ArgumentError, 'Content cannot be blank' if content.blank?
      raise ArgumentError, 'Status must be published' unless status == 'published'

      article.assign_attributes(attributes)
      article.title = title
      article.content = content
      article.status = status

      article.save!
      article
    end
  end
end
