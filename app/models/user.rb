class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true
  after_create :send_confirmation_email
  private
  def send_confirmation_email
    # Assuming UserMailer is a defined mailer class
    UserMailer.with(user: self).confirmation_email.deliver_later
  end
end
