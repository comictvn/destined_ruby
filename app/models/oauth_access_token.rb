class OauthAccessToken < ApplicationRecord
  self.table_name = 'oauth_access_tokens'

  belongs_to :oauth_application

  # Add polymorphic association to resource_owner
  belongs_to :resource_owner, polymorphic: true

  validates :token, presence: true, uniqueness: true
  validates :refresh_token, uniqueness: true, allow_nil: true
  validates :expires_in, numericality: { only_integer: true }, allow_nil: true
  validates :scopes, presence: true
  validates :previous_refresh_token, presence: true
  validates :resource_owner_type, presence: true
  validates :refresh_expires_in, numericality: { only_integer: true }, allow_nil: true
end
