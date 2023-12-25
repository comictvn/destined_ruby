class MatchFeedback < ApplicationRecord
  # associations can be added here if MatchFeedback is related to other models, for example:
  # belongs_to :user
  # belongs_to :match

  # validations
  validates :feedback_text, presence: true
  validates :feedback_text, length: { maximum: 500 }, if: :feedback_text?

  # custom methods can be added here if necessary
end
