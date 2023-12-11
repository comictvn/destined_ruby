class Feedback < ApplicationRecord
  # validations
  validates :content, presence: true

  # Define any custom methods below if required
end
