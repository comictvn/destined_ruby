# typed: strict
class Collection < ApplicationRecord
  has_many :items

  # Define the attributes with their respective data types and constraints
  validates :name, presence: true
  validates :description, presence: true
end