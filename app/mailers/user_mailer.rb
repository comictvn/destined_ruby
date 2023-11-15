class UserMailer < ApplicationMailer
  def registration_confirmation(email)
    @user = User.find_by(email: email)
    @confirmation_link = confirmation_link(@user)
    mail(to: @user.email, subject: 'Registration Confirmation', body: "Please click on the link below to confirm your registration.\n#{@confirmation_link}")
  end
  def confirmation_email(user)
    @user = user
    @confirmation_link = confirmation_link(@user)
    mail(to: @user.email, subject: 'Email Confirmation', body: "Please click on the link below to confirm your email address.\n#{@confirmation_link}")
  end
  private
  def confirmation_link(user)
    Rails.application.routes.url_helpers.confirmation_url(user.confirmation_token, host: 'your-app-domain.com')
  end
end
