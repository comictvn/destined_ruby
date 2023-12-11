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

  # New method to record swipe action
  def record_swipe_action(user_id, target_user_id, swipe_direction)
    ActiveRecord::Base.transaction do
      # Validate the existence of both users
      user = User.find_by(id: user_id)
      target_user = User.find_by(id: target_user_id)
      raise 'User not found' unless user
      raise 'Target user not found' unless target_user

      # Validate swipe direction
      raise 'Invalid swipe direction' unless ['right', 'left'].include?(swipe_direction)

      # Check for an existing swipe action in the opposite direction
      existing_swipe = SwipeAction.find_by(user_id: target_user_id, target_user_id: user_id, swipe_direction: swipe_direction == 'right' ? 'left' : 'right')
      
      # If a mutual interest is found (both users swiped right)
      if swipe_direction == 'right' && existing_swipe
        record_mutual_interest(user_id, user_id, target_user_id)
        return { success: true, message: 'Match made!', match_made: true }
      else
        # Store the swipe action
        SwipeAction.create!(user_id: user_id, target_user_id: target_user_id, swipe_direction: swipe_direction)
        return { success: true, message: 'Swipe recorded', match_made: false }
      end
    end
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
