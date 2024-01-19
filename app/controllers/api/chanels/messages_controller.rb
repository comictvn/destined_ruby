class Api::Chanels::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index destroy]

  def index
    # inside service params are checked and whiteisted
    @messages = MessageService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @messages.total_pages
  end

  def destroy
    @message = Message.find_by('messages.id = ?', params[:id])

    raise ActiveRecord::RecordNotFound if @message.blank?

    authorize @message, policy_class: Api::Chanels::MessagesPolicy

    if @message.destroy
      head :ok, message: I18n.t('common.200')
    else
      head :unprocessable_entity
    end
  end

  def update_article
    required_params = %i[article_id title content]
    unless required_params.all? { |p| params[p].present? }
      render json: { error: 'Missing required parameters' }, status: :bad_request
      return
    end

    article = Article.find_by(id: params[:article_id])
    raise ActiveRecord::RecordNotFound unless article

    authorize article, policy_class: Api::ArticlesPolicy

    if params[:status] == 'published'
      if ArticleService::Update.call(article: article, title: params[:title], content: params[:content], status: params[:status])
        render json: { message: 'Article updated successfully', article: article }, status: :ok
      else
        render json: { error: 'Unable to update article' }, status: :unprocessable_entity
      end
    end
  rescue Pundit::NotAuthorizedError
    render json: { error: 'You are not authorized to perform this action' }, status: :forbidden
  end
end
