module Api
  class ArticlesController < Api::BaseController
    before_action :authenticate_user!, except: [:create_draft]
    before_action :doorkeeper_authorize!, except: [:create_draft, :publish]
    before_action :authorize_create_draft, only: [:create_draft]
    before_action :set_user_and_validate, only: [:manage]

    def index
      user_id = params[:user_id]

      if user_id.blank? || !user_id.match?(/\A\d+\z/)
        render json: { error: I18n.t('controller.articles.missing_user_id') }, status: :bad_request
        return
      end

      articles = ArticleService::Index.new.retrieve_articles(user_id: user_id.to_i)

      authorize articles, policy_class: Api::UsersPolicy

      render json: articles.map { |article| ArticleSerializer.new(article) }, status: :ok
    end

    def publish
      article_id = params[:id].to_i
      status = params[:status]

      if article_id <= 0
        render json: { error: I18n.t('controller.articles.invalid_article_id_format') }, status: :bad_request
        return
      elsif !Article.exists?(article_id)
        render json: { error: I18n.t('controller.articles.article_not_found') }, status: :not_found
        return
      end

      article = Article.find(article_id)
      authorize ArticlePolicy.new(current_user, article), :publish?

      begin
        message = ArticleService::Publish.new.publish(article_id: article_id, status: status)
        render json: { message: message, article: ArticleSerializer.new(article).serializable_hash }, status: :ok
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end

    def create_draft
      permitted_params = draft_params
      if permitted_params[:status] != 'draft'
        render_error('Invalid status value.', status: :bad_request)
        return
      end

      unless User.exists?(permitted_params[:user_id])
        render_error('User not found', status: :bad_request)
        return
      end

      if permitted_params[:title].blank?
        render_error('Title is required.', status: :bad_request)
        return
      end

      if permitted_params[:content].blank?
        render_error('Content is required.', status: :bad_request)
        return
      end

      result = CreateDraft.call(permitted_params)
      article = Article.find(result)
      render json: {
        status: 200,
        message: "Draft saved successfully.",
        article: ArticleSerializer.new(article).as_json
      }, status: :ok
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

    def manage
      authorize ArticlesPolicy.new(current_user, Article), :update?

      articles, total_pages = ArticleService::Index.new.manage_articles(
        user_id: @user.id,
        status: params[:status],
        page: params[:page],
        limit: params[:limit]
      )

      render json: {
        articles: articles.map { |article| ArticleSerializer.new(article) },
        total_pages: total_pages,
        limit: params[:limit].to_i,
        page: params[:page].to_i
      }, status: :ok
    end

    private

    def set_user_and_validate
      @user = User.find_by(id: params[:user_id])
      render json: { error: 'User not found.' }, status: :bad_request and return unless @user
      render json: { error: 'Invalid status value.' }, status: :bad_request and return unless Article.statuses.include?(params[:status])
      page_number = params[:page].to_i
      render json: { error: 'Invalid page number.' }, status: :bad_request and return unless page_number.positive?
      render json: { error: 'Invalid limit value.' }, status: :bad_request and return unless params[:limit].match?(/\A\d+\z/)
    end

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
