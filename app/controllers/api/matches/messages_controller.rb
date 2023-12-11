# FILE PATH: /app/controllers/api/matches/messages_controller.rb

module Api
  module Matches
    class MessagesController < ApplicationController
      before_action :authenticate_user!
      before_action :validate_sender, only: [:create]
      before_action :validate_message_content, only: [:create]

      def create
        service = MessageCreationService.new
        result = service.create_message(params[:match_id], current_user.id, message_params[:content])

        if result[:success]
          render json: {
            status: 201,
            message: {
              id: result[:message].id,
              match_id: result[:message].match_id,
              sender_id: current_user.id,
              content: result[:message].content,
              created_at: result[:message].created_at
            }
          }, status: :created
        else
          render json: { errors: result[:error] }, status: :unprocessable_entity
        end
      end

      private

      def message_params
        params.require(:message).permit(:content)
      end

      def validate_sender
        match = Match.find_by(id: params[:match_id])
        unless match && (match.matcher1_id == current_user.id || match.matcher2_id == current_user.id)
          render json: { error: 'Sender not part of the match.' }, status: :unauthorized and return
        end
      end

      def validate_message_content
        if message_params[:content].blank?
          render json: { error: 'Message content cannot be empty.' }, status: :bad_request and return
        end
      end
    end
  end
end
