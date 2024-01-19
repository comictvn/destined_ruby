class OauthApplication < ApplicationRecord
  # Specify the table name if it's not the pluralized form of the model name
  self.table_name = 'oauth_applications'

  # Define relationships with other models
  has_many :oauth_access_grants, foreign_key: :oauth_application_id, dependent: :destroy
  has_many :oauth_access_tokens, foreign_key: :oauth_application_id, dependent: :destroy

  # Add validations for model attributes
  validates :name, presence: true
  validates :uid, presence: true, uniqueness: true
  validates :secret, presence: true
  validates :redirect_uri, presence: true
  validates :scopes, presence: true
  validates :confidential, inclusion: { in: [true, false] }
end
