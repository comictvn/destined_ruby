# /app/services/match_feedback_service.rb
module Exceptions
  class BadRequest < StandardError; end
end

class MatchFeedbackService
  def create_feedback(match_id, user_id, feedback_text)
    match = Match.find_by(id: match_id)
    raise Exceptions::BadRequest, 'Match not found' unless match

    if match.matcher1_id != user_id && match.matcher2_id != user_id
      raise Exceptions::BadRequest, 'User not involved in the match'
    end

    feedback = MatchFeedback.new(
      match_id: match_id,
      user_id: user_id,
      feedback_text: feedback_text,
      created_at: Time.current
    )

    if feedback.save
      # Assuming MatchFeedbackProcessingJob exists and is configured
      MatchFeedbackProcessingJob.perform_later(feedback.id)
      { status: :success, feedback: feedback }
    else
      raise Exceptions::BadRequest, 'Feedback could not be saved'
    end
  end
end
