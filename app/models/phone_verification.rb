# typed: strict
class PhoneVerification < ApplicationRecord
  validates :phone_number, presence: true
  validates :country_code, presence: true
  validates :verification_code, presence: true
  validates :verified, inclusion: { in: [true, false] }
  validates :sent_at, presence: true
end