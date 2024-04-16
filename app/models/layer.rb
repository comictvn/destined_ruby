
# typed: strict
require 'exceptions'
class Layer < ApplicationRecord
  belongs_to :design_file
  has_many :color_styles

  validates :name, presence: true
  validates :design_file_id, presence: true

  # Determines if the layer is eligible for color style application
  def eligible_for_color_styles?
    # Replace with actual attribute checks if different
    locked = self.locked # Assuming 'locked' is an attribute of Layer
    hidden = self.hidden # Assuming 'hidden' is an attribute of Layer

    if locked || hidden # If the layer is locked or hidden, it is not eligible for color styles
      # Raise a custom exception with a translated error message
      raise Exceptions::LayerIneligibleError.new(I18n.t('controller.layers.layer_not_eligible'))
    else
      true
    end
  end
end
