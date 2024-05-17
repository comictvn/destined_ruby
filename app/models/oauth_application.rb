# typed: strict
class OauthApplication < ApplicationRecord
  has_many :access_tokens, class_name: 'OauthAccessToken', foreign_key: 'application_id', dependent: :destroy
  has_many :access_grants, class_name: 'OauthAccessGrant', foreign_key: 'application_id', dependent: :destroy

  validates :name, presence: true
  validates :uid, presence: true
  validates :secret, presence: true
end
