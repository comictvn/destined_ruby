class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'
  def confirmation_instructions(user)
    @confirmation_link = confirmation_url(user)
    mail(to: user.email, subject: 'Confirmation Instructions')
  end
  private
  def confirmation_url(user)
    "http://example.com/confirm?email=#{user.email}"
  end
end
