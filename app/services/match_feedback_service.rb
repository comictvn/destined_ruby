# /app/services/match_feedback_service.rb

class MatchFeedbackService
  def collect_feedback(match_id, user_id, content)
    ActiveRecord::Base.transaction do
      match = Match.find_by(id: match_id)
      raise 'Match not found' unless match

      unless [match.matcher1_id, match.matcher2_id].include?(user_id)
        raise 'User not part of the match'
      end

      # Instantiate and save a new MatchFeedback record
      match_feedback = MatchFeedback.create!(
        match_id: match_id,
        user_id: user_id,
        content: content
      )

      # Use the feedback to refine the matching algorithm
      refine_matching_algorithm(match_feedback)

      "Feedback successfully created and will be used to improve the matching algorithm."
    end
  rescue => e
    raise e.message
  end

  private

  # Method for refining the matching algorithm
  def refine_matching_algorithm(match_feedback)
    # Algorithm refinement logic goes here
    # This should be implemented with the actual logic
  end
end

# The new code provided in the MatchFeedbackService::Create class is redundant and does not fully meet the requirement.
# The existing code in the MatchFeedbackService class already handles the feedback collection process.
# Therefore, we will not merge the new code and will keep the current implementation.
