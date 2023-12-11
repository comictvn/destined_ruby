class Feedback < ApplicationRecord
  # validations
  validates :content, presence: true
  validates :comment, presence: true, length: { maximum: 500 }
  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  # Define any custom methods below if required
end
