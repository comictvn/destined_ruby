module Api
  class ArticlesController < Api::BaseController
    before_action :authenticate_user!, except: [:create_draft]
    before_action :doorkeeper_authorize!, except: [:create_draft, :publish, :add_metadata]
    before_action :authorize_create_draft, only: [:create_draft]
    before_action :set_article, only: [:update, :update_draft, :add_metadata]
    before_action :validate_article_params, only: [:update], if: -> { action_name == 'update' }

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
      article_id = params[:id]
      status = params[:status]

      if article_id.blank? || !article_id.match?(/\A\d+\z/)
        render json: { error: I18n.t('controller.articles.invalid_article_id_format') }, status: :bad_request
        return
      end

      article_id = article_id.to_i

      if article_id <= 0 || !Article.exists?(article_id)
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
      result = CreateDraft.call(permitted_params)
      render_response({ article_id: result })
    rescue => e
      render_error(e.message, status: :unprocessable_entity)
    end

    def update
      authorize(@article)

      if @article.update(article_params)
        render json: { status: 200, message: I18n.t('controller.articles.update_success'), article: ArticleSerializer.new(@article) }, status: :ok
      else
        render json: { error: @article.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: I18n.t('common.404') }, status: :not_found
    end

    def update_draft
      authorize(@article)

      title = params[:title]
      content = params[:content]

      if title.length > 200
        render json: { error: I18n.t('activerecord.errors.messages.too_long', count: 200) }, status: :unprocessable_entity
        return
      end

      if content.length > 10000
        render json: { error: I18n.t('activerecord.errors.messages.too_long', count: 10000) }, status: :unprocessable_entity
        return
      end

      updated_article = ArticleService::Update.call(article: @article, title: title, content: content, status: 'draft')

      if updated_article
        render json: { status: 200, message: I18n.t('controller.articles.draft_updated'), article: ArticleSerializer.new(updated_article) }, status: :ok
      else
        render json: { error: I18n.t('common.422') }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: I18n.t('common.404') }, status: :not_found
    end

    def add_metadata
      tags = params[:tags]
      categories = params[:categories]
      featured_image = params[:featured_image]

      unless Tag.tags_exist?(tags)
        render_error('One or more tags are invalid.', status: :bad_request)
        return
      end

      unless Category.categories_exist?(categories)
        render_error('One or more categories are invalid.', status: :bad_request)
        return
      end

      unless valid_url?(featured_image)
        render_error('Invalid URL for featured image', status: :bad_request)
        return
      end

      authorize @article, policy_class: Api::ArticlesPolicy

      ArticleService.add_metadata_to_article(@article, tags, categories, featured_image)
      render_response({ message: 'Metadata added successfully.', article: ArticleSerializer.new(@article) })
    end

    def destroy
      id = params[:id]
      raise Exceptions::BadRequest, 'Invalid article ID format.' unless id.match?(/\A\d+\z/)

      article = Article.find_by(id: id)
      if article.nil?
        render json: { error: 'Article not found.' }, status: :not_found
        return
      end

      authorize ArticlePolicy.new(current_user, article), :destroy?

      ArticleService::Delete.new(id).execute
      render json: { message: 'Article deleted successfully.' }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Article not found.' }, status: :not_found
    rescue Exceptions::BadRequest => e
      render json: { error: e.message }, status: :bad_request
    end

    private

    def set_article
      id = params[:id]
      unless id.match?(/\A\d+\z/)
        render json: { error: I18n.t('controller.articles.invalid_article_id_format') }, status: :bad_request
        return
      end

      @article = Article.find_by(id: id)
      render json: { error: I18n.t('controller.articles.article_not_found') }, status: :not_found unless @article
    end

    def validate_article_params
      render json: { error: I18n.t('controller.articles.invalid_id_format') }, status: :bad_request unless params[:id].match?(/\A\d+\z/)
      render json: { error: I18n.t('controller.articles.title_too_long') }, status: :bad_request if params[:title].length > 200
      render json: { error: I18n.t('controller.articles.content_too_long') }, status: :bad_request if params[:content].length > 10000
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

    def valid_url?(url)
      uri = URI.parse(url)
      uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    rescue URI::InvalidURIError
      false
    end
  end
end
