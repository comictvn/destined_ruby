class Api::Chanels::MessagesPolicy < ApplicationPolicy
  def index?
    user_chanels = Chanel.joins(:user_chanels).where(user_chanels: { user_id: user.id })
    user_chanels.exists?(record.id)
  end

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
