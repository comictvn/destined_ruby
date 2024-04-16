
# typed: strict
class Layer < ApplicationRecord
  belongs_to :design_file
  has_many :color_styles
  belongs_to :color_style, optional: true

  validates :name, presence: true
  validates :design_file_id, presence: true
end
