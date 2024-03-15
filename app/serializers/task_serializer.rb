class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :due_date, :priority, :user_id, :assigned_user_id, :created_at

  def user_id
    object.user.id
  end

  def assigned_user_id
    object.assignee&.id
  end
end
