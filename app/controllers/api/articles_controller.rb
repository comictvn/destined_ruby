module Api
  class ArticlesController < Api::BaseController
    before_action :authenticate_user!, except: [:create_draft]
    before_action :doorkeeper_authorize!, except: [:create_draft, :publish]
    before_action :authorize_create_draft, only: [:create_draft]

    def publish
      article_id = params[:id]
      status = params[:status]

      authorize ArticlePolicy.new(current_user, Article.find(article_id)), :publish?

      begin
        message = ArticleService::Publish.new.publish(article_id: article_id, status: status)
        render json: { message: message }, status: :ok
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end

    def create_draft
      permitted_params = draft_params
      result = CreateDraft.call(permitted_params)
      render_response({ article_id: result })
    rescue => e
      render_error(e.message, status: :unprocessable_entity)
    end

    def update
      article = Article.find(params[:id])
      authorize(article, policy_class: Api::ArticlesPolicy)

      raise Exceptions::BadRequest if params[:title].blank? || params[:content].blank?
      raise Exceptions::BadRequest unless ['draft', 'published'].include?(params[:status])

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
