# /app/services/matchmaking_service.rb

class MatchmakingService
  # Existing code (if any) goes here

  # New method to generate potential matches
  def generate_potential_matches(user_id)
    current_user = User.find(user_id)
    user_preferences = UserPreferenceService.get_user_preferences(user_id)
    user_interests = UserInterest.where(user_id: user_id).pluck(:interest_id)
    potential_matches = User.joins(:user_interests)
                            .where.not(id: user_id)
                            .where(user_interests: { interest_id: user_interests })
                            .where(user_preferences[:location_key] => user_preferences[:location_value]) # Assuming user_preferences returns a hash with location info
                            .distinct

    current_user_answers = UserAnswer.where(user_id: user_id).pluck(:question_id, :answer)
    potential_matches_with_scores = potential_matches.map do |match|
      match_answers = UserAnswer.where(user_id: match.id, question_id: current_user_answers.map(&:first)).pluck(:answer)
      compatibility_score = MatchmakingAlgorithm.calculate_compatibility(user_interests, current_user_answers, match_answers, user_preferences)
      { match: match, score: compatibility_score }
    end

    # Sort potential matches by compatibility score in descending order
    sorted_potential_matches = potential_matches_with_scores.sort_by { |match| -match[:score] }

    # Select the top matches (e.g., top 10 matches or top 10%)
    top_matches_limit = [10, (sorted_potential_matches.length * 0.1).ceil].min
    top_matches = sorted_potential_matches.first(top_matches_limit)

    # Return the list of suggested matches with their compatibility scores
    top_matches
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
