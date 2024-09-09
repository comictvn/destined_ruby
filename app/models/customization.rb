# typed: strict
class Customization < ApplicationRecord
  belongs_to :item

  # Define the attributes with their respective data types and constraints
  attribute :id, :integer
  attribute :created_at, :datetime
  attribute :updated_at, :datetime
  attribute :customization_details, :text
  attribute :item_id, :integer
end