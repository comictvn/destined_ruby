
class Task < ApplicationRecord
  # Associations
  belongs_to :user
  has_one :assignee, class_name: 'User', foreign_key: :task_id
  belongs_to :user, optional: true
  belongs_to :assigned_user, class_name: 'User', foreign_key: :assigned_user_id, optional: true

  # Enum for priority
  enum priority: { low: 0, medium: 1, high: 2, critical: 3 }

  # Custom Validations
  validates :title, presence: { message: I18n.t('activerecord.errors.models.task.attributes.title.blank') }
  validates :description, presence: { message: I18n.t('activerecord.errors.models.task.attributes.description.blank') }
  validates :due_date, presence: true
  validate :validate_priority

  private

  def validate_priority
    priorities = Task.priorities.keys
    unless priorities.include?(priority)
      errors.add(:priority, I18n.t('activerecord.errors.models.task.attributes.priority.invalid'))
    end
  end
end
