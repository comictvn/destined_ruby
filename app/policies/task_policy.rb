class TaskPolicy < ApplicationPolicy
  attr_reader :user, :task

  def initialize(user, task)
    @user = user
    @task = task
  end

  def create?
    # Assuming 'admin' and 'manager' roles are allowed to create tasks
    # This logic may change depending on the application's specific authorization requirements
    user.role == 'admin' || user.role == 'manager'
  end
end
