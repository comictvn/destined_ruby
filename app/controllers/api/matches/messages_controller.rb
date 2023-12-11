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
          # Call the service to create a message with the provided message_text
          result = MessageCreationService.new(
            match_id: match.id,
            sender_id: current_user.id,
            receiver_id: receiver_id,
            content: message_params[:content]
          ).call

          if result[:success]
            # Update the match's last_message_at timestamp
            match.update(last_message_at: Time.current)

            # Send a notification to the receiver
            NotificationService.new.send_message_notification(receiver_id, result[:message].id)

            # Return the message details along with a success status
            render json: {
              status: 201,
              message: "Message sent successfully.",
              conversation: {
                id: match.id,
                match_id: match.id,
                messages: [
                  {
                    sender_id: current_user.id,
                    receiver_id: receiver_id,
                    content: result[:message].content,
                    created_at: result[:message].created_at
                  }
                ]
              }
            }, status: :created
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
          ActiveRecord::Base.transaction do
            message = Message.create!(
              match_id: match.id,
              sender_id: current_user.id,
              receiver_id: receiver_id,
              content: message_params[:content]
            )
            yield(match, receiver_id) if block_given?
          end
        else
          render json: { error: 'Match not found or you are not part of the match.' }, status: :not_found
        end
      rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
      end

      def message_params
        # Permit content in the strong parameters
        params.require(:message).permit(:content)
      end

      def validate_sender
        match = Match.find_by(id: params[:match_id])
        unless match && (match.matcher1_id == current_user.id || match.matcher2_id == current_user.id)
          render json: { error: 'Invalid sender or receiver.' }, status: :forbidden and return
        end
      end

      def validate_message_content
        unless message_params[:content].is_a?(String)
          render json: { error: 'Invalid message.' }, status: :bad_request and return
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
