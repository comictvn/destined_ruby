# typed: strict
class SocialAuth < ApplicationRecord
  # Add validations here, for example:
  validates :provider, presence: true
  validates :provider_user_id, presence: true
  validates :access_token, presence: true
  # Add any relationships here, for example:
  # belongs_to :user
end