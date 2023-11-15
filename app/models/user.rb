require 'digest'
class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true
  before_save :encrypt_password
  def encrypt_password
    self.password = Digest::SHA256.hexdigest password
  end
end
