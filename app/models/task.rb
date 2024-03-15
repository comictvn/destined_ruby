class Task < ApplicationRecord
  # Associations
  belongs_to :user
  has_one :assignee, class_name: 'User', foreign_key: :task_id
  belongs_to :user, optional: true
  belongs_to :assigned_user, class_name: 'User', foreign_key: :assigned_user_id, optional: true

  # Validations
  validates :title, presence: { message: I18n.t('activerecord.errors.messages.task.title.blank') }
  validates :description, presence: { message: I18n.t('activerecord.errors.messages.task.description.blank') }
  validates :due_date, presence: true, date: { message: I18n.t('activerecord.errors.messages.task.due_date.invalid') }
  validate :validate_priority

  private

  def validate_priority
    errors.add(:priority, I18n.t('activerecord.errors.messages.task.priority.invalid')) unless Task.priorities.keys.include?(priority)
  end
end
