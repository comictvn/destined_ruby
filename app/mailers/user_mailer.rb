class UserMailer < ApplicationMailer
  def send_confirmation_email(user)
    @user = user
    mail(to: @user.email, subject: 'Confirmation email', body: 'Please click on the link below to confirm your email address.')
  end
end
