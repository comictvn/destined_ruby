class Baseservice < ApplicationRecord
  # validations
  validates :health_check, length: { in: 0..255 }, if: :health_check?
end
