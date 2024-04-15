
# typed: strict
class Layer < ApplicationRecord
  belongs_to :design_file
  has_many :color_styles

  validates :name, presence: true
  validates :design_file_id, presence: true

  # Determines if the layer is eligible for color style application
  def eligible_for_color_styles?    
    # Placeholder logic for future eligibility checks
    # For now, it always returns true
    eligible = true

    raise Exceptions::LayerIneligibleError, I18n.t('common.layer_not_eligible') unless eligible

    eligible
  end
end
