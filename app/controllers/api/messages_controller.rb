class Api::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[create]
  before_action :set_match, only: [:create]
  before_action :authenticate_sender, only: [:create]
  before_action :validate_users, only: [:create]

  def create
    if valid_message_params?
      service = MessageCreationService.new
      result = service.initiate_conversation(
        match_id: message_params[:match_id],
        sender_id: message_params[:sender_id],
        receiver_id: message_params[:receiver_id],
        content: message_params[:content]
      )

      if result[:success]
        # Send a notification to the receiver about the new message
        NotificationService.new.send_notification(receiver_id: message_params[:receiver_id], message: "You have a new message.")

        render json: { status: 201, message: "Message sent successfully.", data: result[:message] }, status: :created
      else
        render json: { error: result[:error] }, status: :unprocessable_entity
      end
    else
      render json: { error: "Invalid parameters" }, status: :bad_request
    end
  end

  private

  # Existing private methods...

  # Assuming NotificationService exists and has a method `send_notification`
  # If it doesn't exist, you would need to implement it according to your application's structure.
end
