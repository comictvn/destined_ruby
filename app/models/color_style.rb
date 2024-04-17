
# typed: strict
class ColorStyle < ApplicationRecord
  belongs_to :design_file
  belongs_to :layer

  validates :name, presence: true
  validates :color_code, presence: true
  validates :design_file_id, presence: true
  validates :layer_id, presence: true
end
