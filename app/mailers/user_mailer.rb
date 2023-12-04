class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'
  def welcome_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end
  def confirmation_email(user)
    @user = user
    @url  = 'http://example.com/confirmation'
    mail_status = mail(to: @user.email, subject: 'Confirmation Email')
    return mail_status
  end
end
