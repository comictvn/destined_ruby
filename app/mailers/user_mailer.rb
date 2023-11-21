class UserMailer < ApplicationMailer
  def registration_confirmation(email)
    @user = User.find_by(email: email)
    @confirmation_link = confirmation_link(@user)
    mail(to: @user.email, subject: 'Registration Confirmation', body: "Please click on the link below to confirm your registration.\n#{@confirmation_link}")
  end
  def send_match_notification(user, matched_user)
    @user = user
    @matched_user = matched_user
    mail(to: [@user.email, @matched_user.email], subject: 'Match Notification', body: "Congratulations! You have a new match with #{@matched_user.firstname} #{@matched_user.lastname}")
  end
  private
  def confirmation_link(user)
    Rails.application.routes.url_helpers.confirmation_url(user.confirmation_token, host: 'your-app-domain.com')
  end
end
