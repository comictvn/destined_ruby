class Api::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[create]

  def create
    @message = Message.new(create_params)

    authorize @message, policy_class: Api::MessagesPolicy

    return if @message.save

    @error_object = @message.errors.messages

    render status: :unprocessable_entity
  end

  def update
    @message = Message.new(create_params)
    @message.update!

  end

  def create_params
    params.require(:messages).permit(:content, :sender_id, :chanel_id, :images)
  end
end
