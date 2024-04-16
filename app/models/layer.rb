
# typed: strict
require_relative '../../lib/exceptions'
class Layer < ApplicationRecord
  belongs_to :design_file
  has_many :color_styles

  validates :name, presence: true
  validates :design_file_id, presence: true

  # Attributes that determine layer's eligibility for color styles
  attribute :locked, :boolean, default: false
  attribute :hidden, :boolean, default: false

  # Checks if the layer is eligible for color style application and raises an exception if not
  def eligible_for_color_styles?
    # Check if the layer is locked or hidden
    raise Exceptions::LayerIneligibleError, I18n.t('controller.design_files.layers.display_color_styles_icon.ineligible_layer_error') if locked || hidden

    true
  end
end
