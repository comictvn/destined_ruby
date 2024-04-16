
# typed: strict
class Layer < ApplicationRecord
  belongs_to :design_file
  has_many :color_styles

  validates :name, presence: true
  validates :design_file_id, presence: true

  # Determines if the layer is eligible for color style application
  def eligible_for_color_styles?
    # Check if the layer has properties such as 'locked' or 'hidden' that would make it ineligible
    # This is a placeholder implementation. Replace with actual attribute checks if different
    locked = false # Placeholder for actual 'locked' attribute check
    hidden = false # Placeholder for actual 'hidden' attribute check

    if locked || hidden
      raise Exceptions::LayerIneligibleError.new(I18n.t('common.layer_not_eligible'))
    else
      true
    end
  end
end
