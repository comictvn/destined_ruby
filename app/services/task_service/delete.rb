# typed: true
module TaskService
  class Delete < BaseService
    def initialize(user)
      @user = user
    end

    def call(id)
      Task.transaction do
        task = Task.find_by(id: id)
        raise Exceptions::BadRequest.new("Task not found") if task.nil?

        # Ensure the task belongs to the authenticated user
        raise Exceptions::BadRequest.new("Task does not belong to the user") unless task.user_id == @user.id

        policy = TaskPolicy.new(@user, task)
        raise Exceptions::AuthenticationError.new("Not authorized to delete this task") unless policy.delete?

        task.destroy
      end
      { message: "Task successfully deleted." }
    rescue ActiveRecord::RecordNotFound => e
      raise Exceptions::BadRequest.new(e.message)
    rescue => e
      raise Exceptions::StandardError.new(e.message)
    end
  end
end
