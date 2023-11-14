class Test5 < ApplicationRecord
  # validations
  validates :id, presence: true
  validates :created_at, presence: true
  validates :updated_at, presence: true
end
