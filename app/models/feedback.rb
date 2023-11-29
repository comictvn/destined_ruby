class Feedback < ApplicationRecord
  # Fields
  validates :feedback, presence: true, length: { maximum: 500 }
  # Associations
  # Callbacks
  # Scopes
  # Class methods
  # Instance methods
  def self.create_feedback(id, feedback_content)
    feedback = Feedback.new(id: id, feedback: feedback_content)
    if feedback.valid?
      feedback.save
      return "Success"
    else
      return feedback.errors.full_messages
    end
  end
end
