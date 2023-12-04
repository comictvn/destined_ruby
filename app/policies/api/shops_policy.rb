class ShopsPolicy < ApplicationPolicy
  def update?
    record.user == user
  end
end
