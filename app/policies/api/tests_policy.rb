class Api::TestsPolicy < ApplicationPolicy
  def update?
    if user.is_a?(User) && record.user_id == user.id
      true
    else
      raise Pundit::NotAuthorizedError, "User does not have permission to access the resource."
    end
  end
  def create?
    # Assuming that only the authorized user can create a new test
    if user.is_a?(User)
      true
    else
      raise Pundit::NotAuthorizedError, "You are not authorized to perform this action."
    end
  end
  class Scope < Scope
    def resolve
      if user.is_a?(User)
        scope.where(user_id: user.id)
      else
        scope.none
      end
    end
  end
end
