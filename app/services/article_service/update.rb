module ArticleService
  class Update
    def self.call(article, attributes)
      article.assign_attributes(attributes)
      article.status = 'draft' unless article.status == 'draft'
      article.save!
      article
    end
  end
end
