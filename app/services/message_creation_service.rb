# /app/services/message_creation_service.rb
class MessageCreationService < BaseService
  def create_message(match_id, sender_id, content)
    ActiveRecord::Base.transaction do
      match = Match.find_by(id: match_id)
      raise Exceptions::BadRequest, 'Match not found' unless match

      unless [match.matcher1_id, match.matcher2_id].include?(sender_id)
        raise Exceptions::AuthenticationError, 'Sender is not part of the match'
      end

      message = Message.create!(
        match_id: match_id,
        sender_id: sender_id,
        content: content
      )

      MessageNotificationJob.perform_later(message.id) if message.persisted?
      { success: true, message: 'Message sent successfully' }
    end
  rescue ActiveRecord::RecordInvalid => e
    { success: false, error: e.message }
  end

  def initiate_conversation(match_id, sender_id, content)
    ActiveRecord::Base.transaction do
      match = Match.find_by(id: match_id)
      raise Exceptions::BadRequest, 'Match not found' unless match

      receiver_id = match.matcher1_id == sender_id ? match.matcher2_id : match.matcher1_id
      unless [match.matcher1_id, match.matcher2_id].include?(sender_id)
        raise Exceptions::AuthenticationError, 'Sender is not part of the match'
      end

      message = Message.create!(
        match_id: match_id,
        sender_id: sender_id,
        receiver_id: receiver_id,
        content: content # Changed from 'message_text' to 'content' to align with the existing column name
      )

      # Update the match with the latest message timestamp
      match.update!(latest_message_at: Time.current) # Assuming 'latest_message_at' is the new column name

      # Assuming NotificationService or a dedicated notification service exists
      NotificationService.notify(receiver_id, message.id) if message.persisted? # Changed from 'UserService' to 'NotificationService'

      { success: true, message: 'Conversation initiated and notification sent to receiver.' } # Updated the response to match the requirement
    end
  rescue ActiveRecord::RecordInvalid => e
    { success: false, error: e.message }
  end
end
