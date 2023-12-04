class Api::Chanels::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index destroy delete_message]
  def index
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
  def delete_message
    chanel = Chanel.find_by(id: params[:chanel_id])
    message = Message.find_by(id: params[:id])
    if chanel.nil? || message.nil?
      render json: { error: 'Chanel or Message not found' }, status: :not_found
    else
      if message.destroy
        render json: { success: 'Message deleted successfully' }, status: :ok
      else
        render json: { error: 'Failed to delete message' }, status: :unprocessable_entity
      end
    end
  end
end
