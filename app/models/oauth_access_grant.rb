# typed: strict
class OauthAccessGrant < ApplicationRecord
  belongs_to :application, class_name: 'OauthApplication', foreign_key: 'application_id', optional: true

  validates :token, presence: true

  # Add any other necessary validations below
  # Example: validates :resource_owner_id, presence: true
end
