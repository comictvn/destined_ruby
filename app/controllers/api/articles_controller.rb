module Api
  class ArticlesController < Api::BaseController
    before_action :authenticate_user!, except: [:create_draft]
    before_action :doorkeeper_authorize!, except: [:create_draft, :publish]
    before_action :authorize_create_draft, only: [:create_draft]
    before_action :set_article, only: [:insert_media]
    before_action :validate_media_params, only: [:insert_media]
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

    def insert_media
      authorize @article, policy_class: Api::MediaPolicy

      media_service = MediaService::Create.new
      media_id = media_service.execute(@article.id, media_params[:file_path], media_params[:media_type])

      render json: {
        status: 200,
        message: "Media content inserted successfully.",
        media: {
          id: media_id,
          article_id: @article.id,
          file_path: media_params[:file_path],
          media_type: media_params[:media_type],
          created_at: Time.now.utc.iso8601
        }
      }, status: :ok
    rescue ActiveRecord::RecordInvalid => e
      render_error(e.message, status: :unprocessable_entity)
    rescue Pundit::NotAuthorizedError => e
      render_error(e.message, status: :forbidden)
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

    def set_article
      @article = Article.find_by(id: params[:id])
      render_error('Article not found.', status: :not_found) unless @article
    end

    def validate_media_params
      render_error('Invalid article ID format.', status: :bad_request) unless params[:id].match?(/\A\d+\z/)
      render_error('Invalid file path or URL.', status: :unprocessable_entity) unless valid_file_path?(media_params[:file_path])
      render_error('Invalid media type.', status: :unprocessable_entity) unless valid_media_type?(media_params[:media_type])
    end

    def valid_file_path?(file_path)
      # Assuming the application has a method to validate file paths or URLs
      # This is a placeholder for the actual validation logic
      file_path.present? && file_path.is_a?(String)
    end

    def valid_media_type?(media_type)
      # Assuming the application has a predefined list of valid media types
      # This is a placeholder for the actual validation logic
      ['image', 'video', 'audio'].include?(media_type)
    end

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

    def media_params
      params.permit(:file_path, :media_type)
    end

    def authorize_create_draft
      authorize :article, :create_draft?
    end
  end
end
