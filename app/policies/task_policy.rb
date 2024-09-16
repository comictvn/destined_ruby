class TaskPolicy < ApplicationPolicy
  attr_reader :user, :task

  def initialize(user, task)
    @user = user
    @task = task
  end

  def create?
    # Assuming 'admin' and 'manager' roles are allowed to create tasks
    # Updated logic to check for specific roles
    # The new and existing code are functionally identical, so we can choose either implementation.
    # Here we choose to use the new code's variable for clarity.
    allowed_roles = ['admin', 'manager']
    allowed_roles.include?(user.role)
  end
end
