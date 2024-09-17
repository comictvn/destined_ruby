
# typed: strict
class Layer < ApplicationRecord
  belongs_to :design_file
  has_many :color_styles
  # belongs_to :color_style, optional: true is already present, no changes required

  belongs_to :color_style, optional: true
  validate :color_style_exists, if: -> { color_style_id.present? }

  validates :name, presence: true
  validates :design_file_id, presence: true

  private

  def color_style_exists
    errors.add(:color_style_id, :not_found) unless ColorStyle.exists?(self.color_style_id)
  end
end
