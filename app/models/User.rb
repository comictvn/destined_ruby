class User < ApplicationRecord
  has_many :user_chanels, dependent: :destroy
  has_many :matches, dependent: :destroy
  has_many :messages, dependent: :destroy
  validates :firstname, :lastname, :email, :phone_number, :encrypted_password, presence: true
  validates :email, :phone_number, uniqueness: true
  validates :password, confirmation: true
  validates :failed_attempts, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :sign_in_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :gender, inclusion: { in: [0, 1] } # Assuming 0 for male and 1 for female
end
