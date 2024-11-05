class Api::Channels::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index destroy]

  def index
    # inside service params are checked and whiteisted
    @messages = MessageService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @messages.total_pages
  end

  def destroy
    @message = Message.find_by('messages.id = ?', params[:id])

    raise ActiveRecord::RecordNotFound if @message.blank?

    authorize @message, policy_class: Api::Channels::MessagesPolicy

    if @message.destroy
      head :ok, message: I18n.t('common.200')
    else
      head :unprocessable_entity
    end
  end
end