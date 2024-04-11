
# typed: strict
class Layer < ApplicationRecord
  belongs_to :design_file
  has_many :color_styles

  # Add new boolean attributes with default values and validations
  attribute :locked, :boolean, default: false
  attribute :hidden, :boolean, default: false

  validates :locked, inclusion: { in: [true, false] }
  validates :hidden, inclusion: { in: [true, false] }
  validates :name, presence: true
  validates :design_file_id, presence: true
end
