class Api::Chanels::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index destroy]

  def index
    chanel = Chanel.find(params[:chanel_id])
    authorize chanel, policy_class: Api::Chanels::MessagesPolicy

    # Merged the service call from new code with parameter handling from existing code
    messages_service = MessageService::Index.new(params.permit!, current_resource_owner)
    messages = messages_service.execute
    # Merged the response rendering from new code with total_pages handling from existing code
    render_response(messages, metadata: { total_pages: messages.total_pages })
  rescue ActiveRecord::RecordNotFound
    # Merged the error handling from new code with the existing code's JSON response
    render json: { error: I18n.t('common.404') }, status: :not_found
  rescue Pundit::NotAuthorizedError
    raise Exceptions::AuthenticationError
  end

  def destroy
    # Merged the message finding logic from both versions
    @message = Message.find_by(id: params[:id], chanel_id: params[:chanel_id])

    if @message.blank?
      render json: { error: I18n.t('common.404') }, status: :not_found
      return
    end

    authorize @message, policy_class: Api::Chanels::MessagesPolicy

    begin
      # Merged the destroy logic from both versions
      if @message.destroy
        head :ok, message: I18n.t('common.200')
      else
        render json: { error: I18n.t('common.422') }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotDestroyed
      render json: { error: I18n.t('common.422') }, status: :unprocessable_entity
    end
  end
end
