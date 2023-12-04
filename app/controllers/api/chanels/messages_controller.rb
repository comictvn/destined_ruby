class Api::Chanels::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index destroy]
  def index
    chanel = Chanel.find_by(id: params[:chanel_id])
    return render json: { error: 'Chanel not found' }, status: :not_found unless chanel
    @messages = MessageService::Index.new(params.permit!.merge(chanel_id: chanel.id), current_resource_owner).execute
    @total_pages = @messages.total_pages
    render json: { messages: @messages, total: @messages.count }, status: :ok
  end
  def destroy
    chanel = Chanel.find_by(id: params[:chanel_id])
    return render json: { error: 'The chanel is not found.' }, status: :not_found unless chanel
    message = Message.find_by(id: params[:id])
    return render json: { error: 'The message is not found.' }, status: :not_found unless message
    authorize message, policy_class: Api::Chanels::MessagesPolicy
    result = MessageService::Delete.new(chanel_id: chanel.id, message_id: message.id).execute
    if result.success?
      render json: { status: 200, message: 'The message was successfully deleted.' }, status: :ok
    else
      render json: { error: result.error }, status: :unprocessable_entity
    end
  end
end
