class Api::Chanels::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index destroy]
  def index
    chanel_id = params[:chanel_id]
    chanel = Chanel.find_by(id: chanel_id)
    if chanel.nil?
      render json: { error: 'Invalid chanel_id' }, status: :unprocessable_entity
      return
    end
    @messages = ChanelService::Index.new(chanel_id, current_resource_owner).execute
    @total_pages = @messages.total_pages
    render 'api/chanels/messages/index', status: :ok
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
end
