class Api::UsersPolicy < ApplicationPolicy
  def show?
    (user.is_a?(User) && record.id == user&.id)
  end

  def designer?
    user.role.in?(['Education', 'Professional', 'Organization'])
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