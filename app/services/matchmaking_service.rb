# /app/services/matchmaking_service.rb

class MatchmakingService
  # Existing code (if any) goes here

  # New method to generate potential matches
  def generate_potential_matches(user_id)
    current_user = User.find(user_id)
    user_preferences = UserPreferenceService.get_user_preferences(user_id) || current_user.user_preferences
    user_interests = UserInterest.where(user_id: user_id).pluck(:interest_id) || current_user.user_interests.pluck(:interest_id)
    potential_matches = User.joins(:user_interests)
                            .where.not(id: user_id)
                            .where(user_interests: { interest_id: user_interests })
                            .select { |user| within_location_range?(user_preferences, user) }
                            .distinct

    current_user_answers = UserAnswer.where(user_id: user_id).pluck(:question_id, :answer) || current_user.user_answers.pluck(:compatibility_question_id, :answer)
    potential_matches_with_scores = potential_matches.map do |match|
      match_answers = UserAnswer.where(user_id: match.id, question_id: current_user_answers.map(&:first)).pluck(:answer) || match.user_answers.where(compatibility_question_id: current_user_answers.map(&:first)).pluck(:answer)
      compatibility_score = MatchmakingAlgorithm.calculate_compatibility(user_interests, current_user_answers, match_answers, user_preferences) || calculate_compatibility_score(user_interests, current_user_answers, match_answers, user_preferences)
      { match: match, score: compatibility_score }
    end

    # Sort potential matches by compatibility score in descending order
    sorted_potential_matches = potential_matches_with_scores.sort_by { |match| -match[:score] }

    # Select the top matches (e.g., top 10 matches or top 10%)
    top_matches_limit = [10, (sorted_potential_matches.length * 0.1).ceil].min
    top_matches = sorted_potential_matches.first(top_matches_limit)

    # Return the list of suggested matches with their compatibility scores
    top_matches
  rescue StandardError => e
    # Handle exceptions, possibly log them or send notifications
    raise "An error occurred while generating potential matches: #{e.message}"
  end

  # New method to record swipe action
  def record_swipe_action(user_id, target_user_id, swipe_direction)
    # Validate user existence
    return { success: false, message: 'Invalid user ID' } unless User.exists?(id: user_id) && User.exists?(id: target_user_id)
    
    # Validate swipe direction
    return { success: false, message: 'Invalid swipe direction' } unless ['right', 'left'].include?(swipe_direction)
    
    # Logic for recording swipe action
    if swipe_direction == 'right'
      # Check for mutual 'right' swipe
      if SwipeLog.exists?(user_id: target_user_id, target_user_id: user_id, swipe_direction: 'right')
        # Create a match
        ActiveRecord::Base.transaction do
          match = Match.create!(user1_id: user_id, user2_id: target_user_id)
          # Remove the swipe logs to prevent duplicate matches
          SwipeLog.where(user_id: user_id, target_user_id: target_user_id, swipe_direction: 'right').destroy_all
          SwipeLog.where(user_id: target_user_id, target_user_id: user_id, swipe_direction: 'right').destroy_all
        end
        return { success: true, message: 'Match created', match: true }
      else
        # Store the swipe action
        SwipeLog.create!(user_id: user_id, target_user_id: target_user_id, swipe_direction: 'right')
      end
    elsif swipe_direction == 'left'
      # Store the swipe action for a 'left' swipe
      SwipeLog.create!(user_id: user_id, target_user_id: target_user_id, swipe_direction: 'left')
    end
    
    # If swipe direction is 'left' or no mutual 'right' swipe, just return success message
    { success: true, message: 'Swipe recorded', match: false }
  end

  private

  def within_location_range?(user_preferences, other_user)
    # Actual location range checking logic should be implemented here
    # For now, we'll assume all users are within the location range
    true
  end

  def calculate_compatibility_score(user_interests, user_answers, match_answers, user_preferences)
    # Compatibility calculation logic goes here
    score = 0
    user_answers.each_with_index do |(question_id, content), index|
      score += 1 if content == match_answers[index]
    end
    score += (user_interests & match_answers.map(&:downcase)).size
    # Additional scoring based on user preferences
    score += calculate_preference_score(user_preferences, match_answers)
    score
  end

  def calculate_preference_score(user_preferences, match_answers)
    # Placeholder for additional preference scoring logic
    # For example, increase score if preferences match certain criteria
    0 # This should be replaced with actual scoring logic
  end
end

# Placeholder class for swipe logs
# This should be replaced with actual implementation of swipe log storage
class SwipeLog
  def self.exists?(user_id:, target_user_id:, swipe_direction:)
    # Logic to check for existing swipe logs
  end

  def self.create!(user_id:, target_user_id:, swipe_direction:)
    # Logic to create a swipe log
  end

  def self.where(user_id:, target_user_id:, swipe_direction:)
    # Logic to find swipe logs
  end
end

# Assuming the existence of the MatchmakingAlgorithm module
module MatchmakingAlgorithm
  def self.calculate_compatibility(user_interests, user_answers, match_answers, user_preferences)
    # Compatibility calculation logic goes here
    # This is a placeholder implementation
    score = 0
    user_answers.each_with_index do |(question_id, content), index|
      score += 1 if content == match_answers[index]
    end
    score += (user_interests & match_answers.map(&:downcase)).size
    # Additional scoring based on user preferences
    score += calculate_preference_score(user_preferences, match_answers)
    score
  end

  def self.calculate_preference_score(user_preferences, match_answers)
    # Placeholder for additional preference scoring logic
    # For example, increase score if preferences match certain criteria
    0 # This should be replaced with actual scoring logic
  end
end
