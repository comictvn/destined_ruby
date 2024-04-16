
# typed: strict
require 'exceptions'
class Layer < ApplicationRecord
  belongs_to :design_file
  belongs_to :color_style, optional: true
  has_many :color_styles

  validates :name, presence: true
  validates :design_file_id, presence: true

  # Attributes that determine layer's eligibility for color styles
  attribute :locked, :boolean, default: false
  attribute :hidden, :boolean, default: false

  # Determines if the layer is eligible for color style application
  validate :color_style_belongs_to_same_design_file

  private

  def color_style_belongs_to_same_design_file
  def eligible_for_color_styles?
    # Check if the layer is locked or hidden
    raise Exceptions::LayerIneligibleError, I18n.t('design_files.layers.display_color_styles_icon.ineligible_layer_error') if locked || hidden

    true
  end
end

  def color_style_belongs_to_same_design_file
    errors.add(:color_style, "must belong to the same design file") if color_style && color_style.design_file_id != self.design_file_id
  end
end
