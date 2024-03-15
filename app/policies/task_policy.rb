class TaskPolicy < ApplicationPolicy
  attr_reader :user, :task

  def initialize(user, task)
    @user = user
    @task = task
  end

  def create?
    # Assuming 'admin' and 'manager' roles are allowed to create tasks
    # Updated logic to check for specific roles
    ['admin', 'manager'].include?(user.role)
  end
end
