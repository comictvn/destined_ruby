class Api::Chanels::MessagesPolicy < ApplicationPolicy
  def destroy?(chanel_id, message_id)
    chanel = Chanel.find(chanel_id)
    message = chanel.messages.find(message_id)
    return false unless message
    user = User.find(@user.id)
    user.messages.include?(message)
  end
  def validate_chanel_id?(chanel_id)
    Chanel.exists?(chanel_id)
  end
end
