# FILE PATH: /app/controllers/api/conversations_controller.rb

class Api::ConversationsController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_users_matched, only: [:create]

  def create
    # Validate that user1_id and user2_id are different
    if params[:user1_id] == params[:user2_id]
      return render json: { error: 'Cannot initiate conversation with oneself.' }, status: :bad_request
    end

    # Check if the conversation already exists between user1_id and user2_id regardless of who initiated it
    existing_conversation = Conversation.where(user1_id: params[:user1_id], user2_id: params[:user2_id])
                                        .or(Conversation.where(user1_id: params[:user2_id], user2_id: params[:user1_id]))
                                        .first
    if existing_conversation
      return render json: { error: 'Conversation already exists.' }, status: :bad_request
    end

    # Call the ConversationService::Create to initiate a new conversation
    # Assuming ConversationService::Create is a valid service that exists and is implemented correctly
    result = ConversationService::Create.new.call(params[:user1_id], params[:user2_id], '')

    # Handle the response from the service object
    if result[:status] == 'success'
      render json: { status: 201, conversation: result[:conversation] }, status: :created
    else
      render json: { error: result[:message] }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_user
    # Implement user authentication logic here
  end

  def ensure_users_matched
    user1 = User.find_by(id: params[:user1_id])
    user2 = User.find_by(id: params[:user2_id])
    unless user1 && user2 && user1.matched_with?(user2)
      render json: { error: 'Match not found.' }, status: :not_found
    end
  end
end
