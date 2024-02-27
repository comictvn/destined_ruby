
class Api::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[create]

  def create
    @message = Message.new(create_params)

    authorize @message, policy_class: Api::MessagesPolicy

    if @message.save
      render json: {
        status: 201,
        message: {
          id: @message.id,
          content: @message.content,
          sender_id: @message.sender_id,
          chanel_id: @message.chanel_id,
          created_at: @message.created_at
        }
      }, status: :created
    else
      render_error(
        error: 'unprocessable_entity',
        message: @message.errors.full_messages.map { |msg| I18n.t(msg) },
        status: :unprocessable_entity
      )
    end
  end

  private

  def create_params
    params.require(:message).permit(:content, :sender_id, :chanel_id, :user_id)
  end
end
