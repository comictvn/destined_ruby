class Api::Chanels::MessagesPolicy < ApplicationPolicy
  def destroy?
    # Assuming that the user is the sender of the message
    # The user can delete the message if he/she is the sender
    record.sender_id == user.id
  end
end
