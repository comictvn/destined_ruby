# typed: strict
class OauthAccessToken < ApplicationRecord
  # Associations
  belongs_to :application, class_name: 'OauthApplication', foreign_key: 'application_id', optional: true

  # Validations
  validates :token, presence: true
  # Add any other necessary validations below
  # Example: validates :resource_owner_id, presence: true
  # Example: validates :expires_in, numericality: { only_integer: true, greater_than: 0 }

  # Include any other model methods, callbacks, or business logic below
end