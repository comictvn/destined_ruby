
# typed: strict
class ColorStyle < ApplicationRecord
  belongs_to :design_file
  belongs_to :layer, optional: true

  validates :name, presence: true
  validates :color_code, presence: true, format: { with: /\A#(?:[0-9a-fA-F]{3}){1,2}\z/i }
  validates :design_file_id, presence: true
end
