class V1::ConversationsController < ApplicationController
  # Other methods...
  def create
    begin
      conversation_params = params.require(:conversation).permit(:match_id, :content)
      message = ConversationsService.new.initiate_conversation(conversation_params)
      render json: { message: message, timestamp: Time.now }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
