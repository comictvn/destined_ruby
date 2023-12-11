# /app/services/match_service.rb

class MatchService
  # Existing methods...

  # New method to record mutual interest
  def record_mutual_interest(user_id, matcher1_id, matcher2_id)
    ActiveRecord::Base.transaction do
      # Check for an existing match entry
      match = Match.find_by(matcher1_id: matcher1_id, matcher2_id: matcher2_id) ||
              Match.find_by(matcher1_id: matcher2_id, matcher2_id: matcher1_id)

      # If a match entry does not exist, create a new one
      unless match
        match = Match.new(matcher1_id: matcher1_id, matcher2_id: matcher2_id)
        match.user_id = user_id if match.respond_to?(:user_id)
        match.save!
      end

      # Send a notification to both users about the match
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
