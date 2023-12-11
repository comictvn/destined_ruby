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
end
