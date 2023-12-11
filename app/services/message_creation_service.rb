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

  def initiate_conversation(match_id, sender_id, receiver_id, content)
    ActiveRecord::Base.transaction do
      match = Match.find_by(id: match_id)
      raise Exceptions::BadRequest, 'Match not found' unless match

      unless [match.matcher1_id, match.matcher2_id].sort == [sender_id, receiver_id].sort
        raise Exceptions::AuthenticationError, 'One of the users is not part of the match'
      end

      message = Message.create!(
        match_id: match_id,
        sender_id: sender_id,
        receiver_id: receiver_id, # Added receiver_id to the message creation as per requirement
        content: content
      )

      # Assuming UserService or a dedicated notification service exists
      UserService.notify(receiver_id, message.id) if message.persisted?

      { success: true, message: 'Notification sent to receiver about the new message' } # Updated the response to match the requirement
    end
  rescue ActiveRecord::RecordInvalid => e
    { success: false, error: e.message }
  end
end
