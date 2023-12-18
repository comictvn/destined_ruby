module FeedbackService
  class Create
    def self.create_feedback(match_id, user_id, comment, rating)
      ActiveRecord::Base.transaction do
        # Validate the match and user participation
        match = Match.find_by(id: match_id)
        raise ActiveRecord::RecordNotFound, 'Match not found' unless match
        raise ActiveRecord::RecordInvalid.new, 'User not involved in the match' unless match.users.exists?(user_id)

        # Create the feedback
        feedback = Feedback.new(
          match_id: match_id,
          user_id: user_id,
          comment: comment,
          rating: rating
        )

        # Save the feedback
        feedback.save!

        # Update the matching algorithm
        # Assuming MatchService::UpdateAlgorithm exists and is the correct method to call
        MatchService::UpdateAlgorithm.call(feedback)

        # Return a confirmation message
        { message: 'Feedback successfully submitted.' }
      end
    rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid => e
      { error: e.message }
    end
  end
end
