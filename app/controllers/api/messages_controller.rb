class Api::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[create send_message]
  def create
    @message = Message.new(message_params)
    authorize @message, policy_class: Api::MessagesPolicy
    if @message.save
      MessageService::Index.new.send_message(@message)
      render json: { message: 'Message sent successfully' }, status: :created
    else
      @error_object = @message.errors.messages
      render json: { errors: @error_object }, status: :unprocessable_entity
    end
  end
  private
  def message_params
    params.require(:message).permit(:sender_id, :receiver_id, :message_content)
  end
end
