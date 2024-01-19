# typed: true
class ArticleService::CreateDraft < BaseService
  def initialize(user_id, title, content, status)
    @user_id = user_id
    @title = title
    @content = content
    @status = status
  end

  def call
    raise ArgumentError, 'User ID, title, and content cannot be blank' if @user_id.blank? || @title.blank? || @content.blank?

    @status = 'draft'

    article = Article.create!(
      user_id: @user_id,
      title: @title,
      content: @content,
      status: @status
    )

    article.id
  rescue => e
    logger.error "ArticleService::CreateDraft Error: #{e.message}"
    nil
  end
end
