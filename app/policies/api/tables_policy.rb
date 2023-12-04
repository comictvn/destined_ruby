class Api::TablesPolicy < ApplicationPolicy
  def create?
    # Assuming that only admin users can create a new table
    if user.is_a?(User) && user.admin?
      true
    else
      raise Pundit::NotAuthorizedError, "You do not have permission to create a new table."
    end
  end
  class Scope < Scope
    def resolve
      if user.is_a?(User) && user.admin?
        scope.all
      else
        scope.none
      end
    end
  end
end
