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

  def initiate_conversation(match_id, sender_id, message_text)
    ActiveRecord::Base.transaction do
      match = Match.find_by(id: match_id)
      raise Exceptions::BadRequest, 'Match not found' unless match

      receiver_id = match.matcher1_id == sender_id ? match.matcher2_id : match.matcher1_id
      unless [match.matcher1_id, match.matcher2_id].include?(sender_id)
        raise Exceptions::BadRequest, 'Invalid match participants'
      end

      message = Message.create!(
        match_id: match_id,
        sender_id: sender_id,
        receiver_id: receiver_id,
        content: message_text
      )

      match.update!(last_message_at: Time.current)

      NotificationService.notify(receiver_id, "You have a new message from #{User.find(sender_id).firstname}") if message.persisted?

      { success: true, message: 'Conversation initiated and notification sent to receiver.' }
    rescue ActiveRecord::RecordInvalid => e
      { success: false, error: e.message }
    rescue StandardError => e
      { success: false, error: e.message }
    end
  end
end
