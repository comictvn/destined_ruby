module Api
  class ArticlesController < BaseController
    before_action :doorkeeper_authorize!, except: [:create_draft]
    before_action :authorize_create_draft, only: [:create_draft]

    def create_draft
      permitted_params = draft_params
      result = CreateDraft.call(permitted_params)
      render_response({ article_id: result })
    rescue => e
      render_error(e.message, status: :unprocessable_entity)
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

    private

    def draft_params
      params.require(:article).permit(:user_id, :title, :content, :status)
    end

    def article_params
      params.permit(:title, :content, :status)
    end

    def authorize_create_draft
      authorize :article, :create_draft?
    end
  end
end
