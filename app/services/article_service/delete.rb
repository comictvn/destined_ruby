# rubocop:disable Style/ClassAndModuleChildren
class ArticleService::Delete
  attr_reader :article_id

  def initialize(article_id)
    @article_id = article_id
  end

  def execute
    article = Article.find(article_id)
    article.destroy
  end
end
# rubocop:enable Style/ClassAndModuleChildren
