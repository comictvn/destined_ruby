class Api::MessagesPolicy < ApplicationPolicy
  def create?
    channel = Chanel.find_by(id: record.chanel_id)
    return false unless channel

    user_channel = UserChanel.find_by(user_id: user.id, chanel_id: channel.id)
    raise Pundit::NotAuthorizedError, I18n.t('common.errors.unauthorized_error') unless user_channel

    true
  end
end
