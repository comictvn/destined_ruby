# /app/services/match_service.rb

class MatchService
  # Existing methods...

  # New method to record mutual interest
  def record_mutual_interest(matcher1_id, matcher2_id)
    ActiveRecord::Base.transaction do
      match = Match.find_by(matcher1_id: matcher1_id, matcher2_id: matcher2_id) ||
              Match.find_by(matcher1_id: matcher2_id, matcher2_id: matcher1_id)

      if match
        match.touch
      else
        match = Match.create!(matcher1_id: matcher1_id, matcher2_id: matcher2_id)
      end

      send_match_notification(match)
    end

    { success: true, message: 'Match recorded successfully.' }
  rescue => e
    { success: false, message: e.message }
  end

  private

  # Actual implementation for sending notifications to both users
  def send_match_notification(match)
    # Assuming NotificationService exists and has a method to send notifications
    NotificationService.new.send_notification_to_users(match.matcher1_id, match.matcher2_id)
  end
end
