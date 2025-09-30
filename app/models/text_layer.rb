# typed: strict
class TextLayer < ApplicationRecord
  belongs_to :design_file
  has_one :text_style, dependent: :destroy
end