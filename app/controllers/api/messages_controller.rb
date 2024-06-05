
class Api::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[create]

  # POST /api/messages
  def create
    message = Message.new(create_params)

    if message.valid?
      message.save
      render json: message, status: :created
    else
      render_error(message.errors.full_messages, status: :unprocessable_entity)
    end
  end

  def update
    @message = Message.new(create_params)
    @message.update!
  end

  private

  def create_params
    params.require(:messages).permit(:content, :sender_id, :chanel_id, images: [])
  end

  def render_error(errors, status:)
    render json: { errors: errors }, status: status
  end
end
