class OauthAccessGrant < ApplicationRecord
  self.table_name = 'oauth_access_grants'

  belongs_to :oauth_application, class_name: 'Doorkeeper::Application', foreign_key: :oauth_application_id

  validates :resource_owner_id, presence: true
  validates :token, presence: true, uniqueness: true
  validates :expires_in, presence: true
  validates :redirect_uri, presence: true
  validates :scopes, presence: true
  validates :resource_owner_type, presence: true

  # Add any additional validations here if needed
end
