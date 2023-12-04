class Api::Chanels::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index destroy]
  before_action :set_chanel, only: [:index]
  def index
    authorize @chanel, policy_class: Api::Chanels::MessagesPolicy
    @messages = MessageService::Index.new(chanel_id: @chanel.id).execute
    if @messages.success?
      render json: { status: 200, messages: @messages.data }, status: :ok
    else
      render json: { error: @messages.error }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'The chanel is not found.' }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end
  def destroy
    chanel = Chanel.find_by(id: params[:chanel_id])
    return render json: { error: 'The chanel is not found.' }, status: :not_found unless chanel
    message = Message.find_by(id: params[:id])
    return render json: { error: 'The message is not found.' }, status: :not_found unless message
    authorize message, policy_class: Api::Chanels::MessagesPolicy
    result = ChanelService::Delete.new(chanel_id: chanel.id, message_id: message.id).execute
    if result.success?
      render json: { status: 200, message: 'The message was successfully deleted.' }, status: :ok
    else
      render json: { error: result.error }, status: :unprocessable_entity
    end
  end
  private
  def set_chanel
    @chanel = Chanel.find(params[:chanel_id])
  end
end
