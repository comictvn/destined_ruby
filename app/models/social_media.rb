class SocialMedia < ApplicationRecord
  belongs_to :user
  # validations
  validates :platform, presence: true
  validates :email, presence: true, uniqueness: true
  validates :email, length: { in: 0..255 }, if: :email?
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: :email_changed?
  # end for validations
end
