class JobDescription < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :details, presence: true
  validates :location_type, presence: true
  validates :city, presence: true
  validates :area, presence: true
  validates :pincode, presence: true
  validates :street_address, presence: true
  validates :status, presence: true
  validates :user_id, presence: true
end