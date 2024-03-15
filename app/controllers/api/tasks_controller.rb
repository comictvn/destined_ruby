
# typed: true
module Api
  class TasksController < BaseController
    before_action :doorkeeper_authorize!
    rescue_from ActiveRecord::RecordInvalid, with: :handle_validation_errors

    def create
      task = Task.new(task_params)

      authorize task, :create?

      task.save!
      render_response(task, status: :created)
    end

    private

    def task_params
      params.require(:task).permit(:title, :description, :due_date, :priority, :user_id)
    end

    def handle_validation_errors(exception)
      render_error(
        error: 'invalid_parameters',
        message: exception.record.errors.full_messages.to_sentence,
        status: :unprocessable_entity
      )
    end
  end
end
