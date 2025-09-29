# typed: strict
class OauthAccessToken < ApplicationRecord
  # Associations
  belongs_to :user, foreign_key: :user_id
  belongs_to :oauth_application, foreign_key: :application_id

  # Validations
  validates :resource_owner_id, presence: true
  validates :token, presence: true, uniqueness: true
  validates :refresh_token, presence: true, uniqueness: true
  validates :expires_in, presence: true
  validates :scopes, presence: true
  validates :resource_owner_type, presence: true
  validates :refresh_expires_in, presence: true
end