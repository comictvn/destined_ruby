# typed: true
module Api
  class TasksController < BaseController
    before_action :doorkeeper_authorize!

    def create
      task = Task.new(task_params)

      if task.save
        render_response(task, status: :created)
      else
        render_error(
          error: 'invalid_parameters',
          message: task.errors.full_messages.to_sentence,
          status: :unprocessable_entity
        )
      end
    end

    private

    def task_params
      params.require(:task).permit(:title, :description, :due_date, :priority, :user_id, :assigned_user_id)
    end
  end
end
