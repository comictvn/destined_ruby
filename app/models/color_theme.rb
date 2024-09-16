
# typed: strict
class ColorTheme < ApplicationRecord
  belongs_to :style, foreign_key: 'style_id'
  validates :name, presence: true
  validates :color_code, presence: true, format: { with: /\A#[0-9a-fA-F]{6}\z/ }

  # Attributes
  attribute :id, :integer
  attribute :created_at, :datetime
  attribute :updated_at, :datetime
  attribute :name, :string
  attribute :color_code, :string
  attribute :style_id, :integer
end
