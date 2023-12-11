# /app/services/matchmaking_service.rb

class MatchmakingService
  # Existing code (if any) goes here

  # New method to generate potential matches
  def generate_potential_matches(user_id)
    current_user = User.find(user_id)
    user_preferences = current_user.user_preferences || UserPreferenceService.get_user_preferences(user_id)
    user_interests = current_user.user_interests.pluck(:interest_id) || UserInterest.where(user_id: user_id).pluck(:interest_id)
    potential_matches = User.includes(:user_interests, :user_answers)
                            .where.not(id: user_id)
                            .where(user_interests: { interest_id: user_interests })
                            .select { |user| within_location_range?(user_preferences, user) }
                            .distinct

    current_user_answers = current_user.user_answers.pluck(:compatibility_question_id, :answer) || UserAnswer.where(user_id: user_id).pluck(:question_id, :answer)
    potential_matches_with_scores = potential_matches.map do |match|
      match_answers = match.user_answers.where(compatibility_question_id: current_user_answers.map(&:first)).pluck(:answer) || UserAnswer.where(user_id: match.id, question_id: current_user_answers.map(&:first)).pluck(:answer)
      compatibility_score = calculate_compatibility_score(user_interests, current_user_answers, match_answers, user_preferences) || MatchmakingAlgorithm.calculate_compatibility(user_interests, current_user_answers, match_answers, user_preferences)
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

  # Existing code for record_swipe_action method goes here

  private

  # Existing private methods go here

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

  # Existing calculate_preference_score method goes here

end

# Existing SwipeLog class goes here

# Existing MatchmakingAlgorithm module goes here
