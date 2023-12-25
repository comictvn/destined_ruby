# /app/services/conversation_service/create.rb

class ConversationService
  class Create
    def initialize_conversation(user1_id, user2_id, initial_message)
      begin
        # Validate that both user1_id and user2_id correspond to existing users
        unless User.exists?(user1_id) && User.exists?(user2_id)
          return { status: 'error', message: 'One or both users do not exist' }
        end

        # Check if there is a match between the two users
        match = Match.where(matcher1_id: user1_id, matcher2_id: user2_id)
                     .or(Match.where(matcher1_id: user2_id, matcher2_id: user1_id))
                     .first
        unless match
          return { status: 'error', message: 'No match found between users' }
        end

        # Create a new conversation entry with user1_id and user2_id
        conversation = Conversation.create!(user1_id: user1_id, user2_id: user2_id)

        # Store the initial_message in the messages table
        initial_message_data = Message.create!(
          content: initial_message,
          sender_id: user1_id,
          receiver_id: user2_id, # Set receiver_id to user2_id
          conversation_id: conversation.id
        )

        # Update the created_at timestamp for conversation and message
        conversation.touch
        initial_message_data.touch

        # Return a hash with the conversation initiation status, conversation ID, and initial message data
        { status: 'success', conversation_id: conversation.id, initial_message: initial_message_data }
      rescue ActiveRecord::RecordInvalid => e
        # Handle exceptions and errors appropriately
        { status: 'error', message: e.message }
      rescue StandardError => e
        { status: 'error', message: e.message }
      end
    end
  end
end
