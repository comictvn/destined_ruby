# FILE PATH: /app/services/task_service/index.rb
class TaskService::Index
  include Kaminari::Helpers::HelperMethods

  attr_accessor :params, :user_id

  def initialize(params, user_id)
    @params = params
    @user_id = user_id
  end

  def execute
    retrieve_user_tasks
  end

  def retrieve_user_tasks
    tasks_query = Task.where(user_id: user_id)
                      .select(:id, :title, :description, :due_date, :status, :created_at, :updated_at)
    paginated_tasks = tasks_query.page(params[:page] || 1).per(params[:per] || 20)
    total_items = tasks_query.count
    total_pages = paginated_tasks.total_pages

    {
      tasks: paginated_tasks,
      total_items: total_items,
      total_pages: total_pages
    }
  rescue ActiveRecord::RecordNotFound
    { tasks: [], total_items: 0, total_pages: 0 }
  end
end
