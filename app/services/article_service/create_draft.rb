# typed: true
class ArticleService::CreateDraft < BaseService
  def initialize(user_id, title, content, status)
    @user_id = user_id
    @title = title
    @content = content
    @status = status
  end

  def call
    # Validate user existence
    raise ArgumentError, 'User not found.' unless User.exists?(@user_id)
    # Validate title and content presence
    raise ArgumentError, 'Title is required.' if @title.blank?
    raise ArgumentError, 'Content is required.' if @content.blank?
    # Validate status
    valid_statuses = ['draft', 'published', 'archived'] # Assuming these are the valid statuses
    raise ArgumentError, 'Invalid status value.' unless valid_statuses.include?(@status)

    @status = 'draft' # Ensure the status is always 'draft' when creating a new draft

    article = Article.create!(
      user_id: @user_id,
      title: @title,
      content: @content,
      status: @status
    )

    # Assuming we have a method to serialize the article to the desired response format
    article_serializer = ArticleSerializer.new(article)
    { status: 200, message: 'Draft saved successfully.', article: article_serializer.serialize }
  rescue ArgumentError => e
    { status: 400, message: e.message }
  rescue => e
    logger.error "ArticleService::CreateDraft Error: #{e.message}"
    { status: 500, message: 'Internal Server Error' }
  end
end
