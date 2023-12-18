class Api::TasksController < Api::BaseController
  include ExceptionHandler

  def create
    # Ensure the user_id is taken from the current authenticated user
    @task = Task.new(task_params.merge(user_id: current_user.id, status: 'pending'))
    @task.created_at = Time.current
    @task.updated_at = Time.current

    if @task.save
      render json: TaskSerializer.new(@task).serialized_json, status: :created
    else
      error_messages = @task.errors.messages
      render json: { error_messages: error_messages, message: I18n.t('tasks.creation.failed') },
             status: :unprocessable_entity
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :due_date)
  end
end
