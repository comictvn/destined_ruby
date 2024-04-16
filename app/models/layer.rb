
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
    raise Exceptions::LayerIneligibleError, I18n.t('common.layer_not_eligible') if locked || hidden
    else
      true
    end
  end
end
