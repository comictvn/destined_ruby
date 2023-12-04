class Api::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[create]
  def create
    @message = Message.new(message_params)
    authorize @message, policy_class: Api::MessagesPolicy
    if @message.save
      render json: @message, status: :created
    else
      render json: { errors: @message.errors.messages }, status: :unprocessable_entity
    end
  end
  private
  def message_params
    params.require(:message).permit(:content)
  end
end