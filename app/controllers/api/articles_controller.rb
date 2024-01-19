class Api::ArticlesController < Api::BaseController
  before_action :doorkeeper_authorize!, except: [:add_metadata]

  def add_metadata
    article_id = params[:article_id]
    tags = params[:tags]

    unless article_id.present? && tags.is_a?(Array) && tags.any?
      render json: { error: 'Invalid parameters' }, status: :bad_request
      return
    end

    service = ArticleService::Index.new
    message = service.add_tags_to_article(article_id, tags)
    render json: { message: message }, status: :ok
  end

  def update
    article = Article.find(params[:id])
    authorize(article)

    raise Exceptions::BadRequest if params[:title].blank? || params[:content].blank?
    raise Exceptions::BadRequest unless params[:status] == 'draft'

    updated_article = ArticleService::Update.call(article, article_params)

    if updated_article
      render json: ArticleSerializer.new(updated_article), status: :ok, message: I18n.t('common.200')
    else
      render json: { error: I18n.t('common.422') }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: I18n.t('common.404') }, status: :not_found
  end

  def destroy
    article = Article.find_by(id: params[:id])

    raise ActiveRecord::RecordNotFound unless article

    authorize(article, :destroy?)

    if article.destroy
      render json: { message: I18n.t('articles.destroy.success') }, status: :ok
    else
      render json: { message: article.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private

  def article_params
    params.permit(:title, :content, :status)
  end
end
