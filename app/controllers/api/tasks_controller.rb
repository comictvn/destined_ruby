class Api::TasksController < Api::BaseController
  include ExceptionHandler

  before_action :set_task, only: [:update]
  before_action :authorize_task, only: [:update]
  before_action :authenticate_user!, only: [:index, :create, :update] # Ensure user is authenticated for index, create, and update actions

  def index
    # Retrieve the tasks belonging to the current user
    tasks = Task.where(user_id: current_user.id)
    render json: { status: 200, tasks: tasks.as_json(only: [:id, :title, :description, :due_date, :created_at, :status]) }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

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

  def update
    if @task.update(update_task_params)
      @task.touch # This line updates the 'updated_at' timestamp
      render json: TaskSerializer.new(@task).serialized_json, status: :ok
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  rescue Exceptions::AuthenticationError, Exceptions::BadRequest => e
    render json: { error: e.message }, status: :forbidden
  end

  private

  def authenticate_user!
    raise Exceptions::AuthenticationError.new("User must be authenticated") unless current_user
  end

  def set_task
    raise Exceptions::BadRequest.new("Invalid task ID format.") unless params[:id].match?(/^\d+$/)
    @task = Task.find_by(id: params[:id])
    raise Exceptions::BadRequest.new("Task not found") if @task.nil?
  end

  def authorize_task
    raise Exceptions::AuthenticationError.new("Not authorized to edit this task") unless TaskPolicy.new(current_user, @task).update?
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date)
  end

  def update_task_params
    params.require(:task).permit(:title, :description, :due_date, :status).tap do |task_params|
      raise Exceptions::BadRequest.new("Title is required.") if task_params[:title].blank?
      raise Exceptions::BadRequest.new("Description is required.") if task_params[:description].blank?
      begin
        DateTime.parse(task_params[:due_date]) if task_params[:due_date].present?
      rescue ArgumentError
        raise Exceptions::BadRequest.new("Invalid due date format.")
      end
    end
  end
end
