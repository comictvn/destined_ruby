
# typed: strict
class ColorStyle < ApplicationRecord
  belongs_to :design_file
  belongs_to :layer

  validates :name, presence: true
  validates :color_code, presence: true, format: { with: /\A#(?:[0-9a-fA-F]{3}){1,2}\z/ }
  validates :design_file_id, presence: true

  # Removed the validation for layer_id as it is not mentioned in the requirements
end
