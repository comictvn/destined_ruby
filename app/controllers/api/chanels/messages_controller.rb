class Api::Chanels::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index destroy]
  def index
    chanel_id = params[:chanel_id]
    chanel = Chanel.find_by(id: chanel_id)
    if chanel.nil?
      render json: { error: 'Invalid chanel_id' }, status: :unprocessable_entity
      return
    end
    @messages = MessageService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @messages.total_pages
    render 'api/chanels/messages/index', status: :ok
  end
  def destroy
    chanel = Chanel.find(params[:chanel_id])
    @message = chanel.messages.find(params[:id])
    raise ActiveRecord::RecordNotFound if @message.blank?
    authorize @message, policy_class: Api::Chanels::MessagesPolicy
    if @message.destroy
      render json: { message: I18n.t('common.200') }, status: :ok
    else
      head :unprocessable_entity
    end
  end
end
