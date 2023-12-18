# FILE PATH: /app/controllers/api/matches/messages_controller.rb

module Api
  module Matches
    class MessagesController < ApplicationController
      before_action :authenticate_user!
      before_action :validate_sender, only: [:create]
      before_action :validate_message_content, only: [:create]
      before_action :validate_match_existence, only: [:create]
      before_action :validate_user_part_of_match, only: [:create]

      def create
        initiate_conversation do |match, receiver_id|
          # Call the service to create a message with the provided message_text or content
          result = MessageCreationService.new(
            current_user, # from new code
            match,
            receiver_id,
            message_params[:message_text] || message_params[:content] # accommodate both parameters
          ).perform # changed to perform to match the new code

          if result[:success]
            # Update the match's last_message_at timestamp
            match.update(last_message_at: Time.current)

            # Send a notification to the receiver
            NotificationService.new.send_message_notification(receiver_id, result[:message].id)

            # Return the message details along with a success status
            # Merged the response format to include both message_text and content
            render json: {
              status: result[:message].persisted? ? 201 : 200, # Use 201 if message is persisted, otherwise 200
              message: "Message sent successfully.",
              conversation: {
                id: match.id,
                match_id: match.id,
                sender_id: current_user.id,
                receiver_id: receiver_id,
                message_text: result[:message].content, # from new code
                content: result[:message].content, # from existing code
                created_at: result[:message].created_at.iso8601(3) # Use iso8601 format from new code
              }
            }, status: result[:message].persisted? ? :created : :ok # Use :created if message is persisted, otherwise :ok
          else
            # Return the error details if the message creation failed
            render json: { errors: result[:errors] }, status: :unprocessable_entity
          end
        end
      end

      private

      def initiate_conversation
        match = Match.find_by(id: params[:match_id])
        if match && (match.matcher1_id == current_user.id || match.matcher2_id == current_user.id)
          receiver_id = match.matcher1_id == current_user.id ? match.matcher2_id : match.matcher1_id
          yield(match, receiver_id) if block_given?
        else
          render json: { error: 'Match not found or you are not part of the match.' }, status: :not_found
        end
      rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
      end

      def message_params
        # Permit both message_text and content in the strong parameters
        params.require(:message).permit(:message_text, :content)
      end

      def validate_sender
        match = Match.find_by(id: params[:match_id])
        unless match && (match.matcher1_id == current_user.id || match.matcher2_id == current_user.id)
          render json: { error: 'Invalid sender or receiver.' }, status: :forbidden and return
        end
      end

      def validate_message_content
        # Check for both message_text and content
        message_text = message_params[:message_text] || message_params[:content]
        unless message_text.is_a?(String) && !message_text.empty?
          render json: { error: 'Message cannot be empty.' }, status: :bad_request and return
        end
      end

      def validate_match_existence
        unless Match.exists?(id: params[:match_id])
          render json: { error: 'Match not found.' }, status: :not_found and return
        end
      end

      def validate_user_part_of_match
        match = Match.find_by(id: params[:match_id])
        if match
          sender_id = current_user.id
          receiver_id = match.matcher1_id == sender_id ? match.matcher2_id : match.matcher1_id
          unless User.exists?(id: sender_id) && User.exists?(id: receiver_id)
            render json: { error: 'Invalid sender or receiver.' }, status: :bad_request and return
          end
        else
          render json: { error: 'Match not found.' }, status: :not_found and return
        end
      end
    end
  end
end
