class Test2344 < ApplicationRecord
  # validations
  validates :id, presence: true
  validates :created_at, presence: true
  validates :updated_at, presence: true
  # end for validations
end
