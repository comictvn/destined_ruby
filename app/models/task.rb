class Task < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true
  validates :due_date, presence: true
  validates :status, presence: true, inclusion: { in: %w[not_started in_progress completed] }
  validates :user_id, presence: true

  # Custom methods (if any)

end
