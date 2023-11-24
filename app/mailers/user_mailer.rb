class UserMailer < ApplicationMailer
  def registration_confirmation(email)
    @user = User.find_by(email: email)
    @confirmation_link = confirmation_link(@user)
    mail(to: @user.email, subject: 'Registration Confirmation', body: "Please click on the link below to confirm your registration.\n#{@confirmation_link}")
  end
  def match_notification(user1, user2)
    @user1 = user1
    @user2 = user2
    @match_status = user1.match.status
    mail(to: [@user1.email, @user2.email], subject: 'Match Notification', body: "The status of your match is #{@match_status}")
  end
  def match_status_update_email(user, match)
    @user = user
    @match = match
    mail(to: @user.email, subject: 'Match Status Update', body: "Your match status has been updated. The status is now: #{@match.status}. The match's user ID is: #{@match.user_id}.")
  end
  private
  def confirmation_link(user)
    Rails.application.routes.url_helpers.confirmation_url(user.confirmation_token, host: 'your-app-domain.com')
  end
end
