class Api::UsersPolicy < ApplicationPolicy
  def show?
    (user.is_a?(User) && record.id == user&.id)
  end
  
  def update?
    user.id == record.id
  end

  class Scope < Scope
    def resolve
      if user.is_a?(User)
        scope.all.where('users.id = ?', user&.id)

      else
        scope.none

      end
    end
  end
end
