# typed: strict
class TextStyle < ApplicationRecord
  belongs_to :text_layer

  validates :name, presence: true
  validates :font_family, presence: true
  validates :font_style, presence: true
  validates :font_size, presence: true, numericality: true
  validates :line_height, presence: true, numericality: true
  validates :letter_spacing, presence: true, numericality: true
  validates :paragraph_alignment, presence: true
  validates :text_transform, presence: true
  validates :text_color, presence: true
  validates :opacity, presence: true, numericality: true
  validates :text_transformation, presence: true
end