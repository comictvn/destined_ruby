class SendConfirmationEmailJob < ApplicationJob
  queue_as :default
  def perform(user_email)
    UserMailer.confirmation_email(user_email).deliver_now
  end
end
