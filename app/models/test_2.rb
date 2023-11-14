class Test2 < ApplicationRecord
  # validations
  validates :name, presence: true
  validates :status, presence: true
  # end for validations
end
