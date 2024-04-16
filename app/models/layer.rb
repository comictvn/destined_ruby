
# typed: strict
class Layer < ApplicationRecord
  belongs_to :design_file
  has_many :color_styles

  validates :name, presence: true
  validates :design_file_id, presence: true

  # Determines if the layer is eligible for color style application
  def eligible_for_color_styles?    
    # Placeholder logic for eligibility check
    # This method should contain the actual logic to check if the layer is eligible
    eligible = true # This should be replaced with the actual eligibility condition

    raise Exceptions::LayerIneligibleError, I18n.t('common.layer_not_eligible') unless eligible

    eligible
  end
end
