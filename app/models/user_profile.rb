# typed: strict
class UserProfile < ApplicationRecord
  belongs_to :user

  # Define the attributes with their respective data types and constraints
  attribute :id, :integer
  attribute :created_at, :datetime
  attribute :updated_at, :datetime
  attribute :order_history, :text
  attribute :settings, :text
  attribute :user_id, :integer
end