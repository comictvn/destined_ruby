# FILE PATH: /app/controllers/api/matches/messages_controller.rb

module Api
  module Matches
    class MessagesController < ApplicationController
      before_action :authenticate_user!
      before_action :validate_sender, only: [:create]
      before_action :validate_message_content, only: [:create]

      def create
        match = Match.find_by(id: params[:match_id])
        receiver_id = match.matcher1_id == current_user.id ? match.matcher2_id : match.matcher1_id

        # Initialize the service with the sender_id, receiver_id, and match_id
        service = MessageCreationService.new(current_user.id, receiver_id, params[:match_id])
        
        # Call the service to create a message with the provided message_text
        result = service.create_message(message_params[:message_text])

        if result[:success]
          # Update the match's last_message_at timestamp
          match.update(last_message_at: Time.current)

          # Send a notification to the receiver
          NotificationService.new.send_message_notification(receiver_id, result[:message].id)

          # Return the message details along with a success status
          render json: {
            status: 201,
            message: {
              id: result[:message].id,
              match_id: result[:message].match_id,
              sender_id: result[:message].sender_id,
              receiver_id: result[:message].receiver_id,
              content: result[:message].content,
              created_at: result[:message].created_at
            }
          }, status: :created
        else
          # Return the error details if the message creation failed
          render json: { errors: result[:errors] }, status: :unprocessable_entity
        end
      end

      private

      def message_params
        # Permit message_text in the strong parameters
        params.require(:message).permit(:message_text)
      end

      def validate_sender
        match = Match.find_by(id: params[:match_id])
        unless match && (match.matcher1_id == current_user.id || match.matcher2_id == current_user.id)
          render json: { error: 'Sender not part of the match.' }, status: :unauthorized and return
        end
      end

      def validate_message_content
        if message_params[:message_text].blank?
          render json: { error: 'Message content cannot be empty.' }, status: :bad_request and return
        end
      end
    end
  end
end
