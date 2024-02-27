class Api::Chanels::MessagesPolicy < ApplicationPolicy
  def destroy?
    user_is_sender? || user_is_admin?
  end

  private

  def user_is_sender?
    user.id == record.sender_id
  end

  def user_is_admin?
    user.admin?
  end
end
