class FeedbackService < BaseService
  def initialize(user_id, match_id, feedback)
    @user_id = user_id
    @match_id = match_id
    @feedback = feedback
  end
  def provide_feedback
    validate_input
    match = find_match
    update_feedback(match)
    refine_matching_algorithm
    "Feedback successfully provided"
  rescue => e
    e.message
  end
  private
  def validate_input
    user_validator = UserValidator.new(@user_id)
    match_validator = MatchValidator.new(@match_id)
    raise ActiveRecord::RecordInvalid, user_validator.errors.full_messages.join(", ") unless user_validator.valid?
    raise ActiveRecord::RecordInvalid, match_validator.errors.full_messages.join(", ") unless match_validator.valid?
  end
  def find_match
    match = Match.find_by(id: @match_id)
    raise ActiveRecord::RecordNotFound, "Match not found" unless match
    match
  end
  def update_feedback(match)
    match.update!(feedback: @feedback)
  end
  def refine_matching_algorithm
    MatchingAlgorithmService.new(@user_id, @match_id, @feedback).refine
  end
end
