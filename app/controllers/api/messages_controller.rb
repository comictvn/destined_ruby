class Api::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[create]
  def create
    # Validate the input data
    validation_result = MessageService::Index.new(params).call
    if validation_result.success?
      # Create a new message
      @message = Message.new(message_params)
      if @message.save
        # Return a success response with the created message's id
        render json: { message: 'Message created successfully', id: @message.id }, status: :created
      else
        @error_object = @message.errors.messages
        render status: :unprocessable_entity
      end
    else
      render json: { error: validation_result.errors }, status: :unprocessable_entity
    end
  end
  private
  def message_params
    params.require(:message).permit(:content, :user_id, :chanel_id)
  end
end
