class Task < ApplicationRecord
  # Associations
  belongs_to :user
  has_one :assignee, class_name: 'User', foreign_key: :task_id

  # Validations
  validates :title, presence: true
  validates :description, presence: true
  validates :due_date, presence: true
end
