class Api::MessagesPolicy < ApplicationPolicy
  def update?
    user.admin? || record.user_id == user.id
  end
end

  def create?; end
end
