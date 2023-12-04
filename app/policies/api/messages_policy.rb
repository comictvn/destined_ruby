class Api::MessagesPolicy < ApplicationPolicy
  def create?
    if user.nil?
      context.fail!(message: "Unauthorized", status: 401)
      return false
    end
    true
  end
end
