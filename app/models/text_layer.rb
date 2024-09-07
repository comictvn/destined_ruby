# typed: strict
class TextLayer < ApplicationRecord
  belongs_to :design_file
  has_one :text_style, dependent: :destroy
  validates :opacity, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end