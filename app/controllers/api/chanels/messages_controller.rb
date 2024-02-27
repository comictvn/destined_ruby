
class Api::Chanels::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index destroy]

  def index
    # inside service params are checked and whiteisted
    @messages = MessageService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @messages.total_pages
  end

  def destroy
    @message = Message.find_by(id: params[:id], chanel_id: params[:chanel_id])

    if @message.blank?
      render json: { error: I18n.t('common.404') }, status: :not_found
      return
    end

    authorize @message, policy_class: Api::Chanels::MessagesPolicy

    begin
      @message.destroy!
      head :ok, message: I18n.t('common.200')
    rescue ActiveRecord::RecordNotDestroyed
      render json: { error: I18n.t('common.422') }, status: :unprocessable_entity
    end
  end
end
