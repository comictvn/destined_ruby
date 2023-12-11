class User < ApplicationRecord
  # Set table name if it's not the pluralized form of the model name
  self.table_name = 'users'

  # Define relationships
  has_many :user_chanels, dependent: :destroy
  has_many :user_interests, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :matchs, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_one :user_preferences, dependent: :destroy
  has_many :user_answers, dependent: :destroy

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :encrypted_password, presence: true
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :phone_number, presence: true, uniqueness: true
  validates :gender, presence: true
  validates :dob, presence: true
  validates :location, presence: true
  validates :interests, presence: true

  # Add any custom methods below
end
