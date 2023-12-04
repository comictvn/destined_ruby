class ShopPolicy < ApplicationPolicy
  def update?
    user.admin? || record.user == user
  end
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end
end
