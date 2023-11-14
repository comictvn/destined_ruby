class Test < ApplicationRecord
  # validations
  validates :name, presence: true
  validates :status, presence: true
end
