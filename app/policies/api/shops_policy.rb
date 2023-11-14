class Api::ShopsPolicy < ApplicationPolicy
  def update?
    # Assuming that only the shop owner can update the shop information
    if user.is_a?(User) && record.user_id == user.id
      true
    else
      raise Pundit::NotAuthorizedError, "You do not have permission to update this shop."
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
