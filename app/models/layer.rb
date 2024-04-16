
# typed: strict
require 'exceptions'
class Layer < ApplicationRecord
  belongs_to :design_file
  has_many :color_styles

  validates :name, presence: true
  validates :design_file_id, presence: true

  # Attributes that determine layer's eligibility for color styles
  attribute :locked, :boolean, default: false
  attribute :hidden, :boolean, default: false

  # Determines if the layer is eligible for color style application
  def eligible_for_color_styles?
    # Check if the layer is locked or hidden
    if self.locked || self.hidden
      raise Exceptions::LayerIneligibleError, I18n.t('design_files.layers.display_color_styles_icon.layer_ineligible')
    else
      true
    end
  end
end
