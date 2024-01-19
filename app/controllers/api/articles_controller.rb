class Api::ArticlesController < Api::BaseController
  before_action :doorkeeper_authorize!

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

  private

  def article_params
    params.permit(:title, :content, :status)
  end
end
