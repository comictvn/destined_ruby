# typed: true
module Api
  class TasksController < BaseController
    before_action :doorkeeper_authorize!
    rescue_from ActiveRecord::RecordInvalid, with: :handle_validation_errors

    # POST /api/tasks
    def create
      # Check if TaskService::Create is defined to determine which code to use
      if defined?(TaskService::Create)
        task_service = TaskService::Create.new(task_params)

        authorize task_service.task, :create?

        result = task_service.execute

        if result.is_a?(Task)
          render_response(TaskSerializer.new(result), status: :created)
        else
          render_error(
            error: 'validation_error',
            message: result,
            status: :unprocessable_entity
          )
        end
      else
        task = Task.new(task_params)

        authorize task, :create?

        task.save!
        render_response(task, status: :created)
      end
    end

    private

    def task_params
      # Merge the new and existing parameters, ensuring compatibility
      params.require(:task).permit(:title, :description, :due_date, :priority, :assigned_user_id, :user_id)
    end

    def handle_validation_errors(exception)
      # Use the new error message format if I18n translation is available
      if I18n.exists?('activerecord.errors.models.task.attributes.base.invalid_parameters')
        render_error(
          error: 'invalid_parameters',
          message: I18n.t('activerecord.errors.models.task.attributes.base.invalid_parameters', errors: exception.record.errors.full_messages.to_sentence),
          status: :unprocessable_entity
        )
      else
        render_error(
          error: 'invalid_parameters',
          message: exception.record.errors.full_messages.to_sentence,
          status: :unprocessable_entity
        )
      end
    end
  end
end
