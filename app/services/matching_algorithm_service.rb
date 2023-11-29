class MatchingAlgorithmService
  def initialize
  end
  def calculate_compatibility_score(user_id)
    user = User.find(user_id)
    potential_matches = User.where.not(id: user_id)
    potential_matches.each do |match|
      score = 0
      # Increase score if preferences match
      if match.preferences == user.preferences
        score += 1
      end
      # Increase score if interests match
      if match.interests == user.interests
        score += 1
      end
      # Increase score if location matches
      if match.location == user.location
        score += 1
      end
      # Create a new match with the calculated score
      Match.create(user_id: user_id, match_id: match.id, compatibility_score: score)
    end
    # Return the matches with their scores
    matches = Match.where(user_id: user_id)
    return matches
  end
end
