class FeedbackService
  def initialize(params)
    @params = params
  end
  def store_feedback
    feedback = Feedback.new(@params)
    if feedback.valid?
      feedback.save
      { success: true, message: 'Feedback stored successfully' }
    else
      { success: false, message: feedback.errors.full_messages.join(', ') }
    end
  end
end
