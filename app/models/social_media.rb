class SocialMedia < ApplicationRecord
  belongs_to :user
  # validations
  validates :platform, presence: true
  validates :email, presence: true, uniqueness: true
  validates :email, length: { in: 0..255 }, if: :email?
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: :email_changed?
  validates :title, length: { in: 0..255 }, allow_nil: true
  validates :content, length: { in: 0..255 }, allow_nil: true
  # end for validations
end
