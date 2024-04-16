
# typed: strict
class Layer < ApplicationRecord
  belongs_to :design_file
  has_many :color_styles

  validates :name, presence: true
  validates :design_file_id, presence: true

  # Determines if the layer is eligible for color style application
  def eligible_for_color_styles?
    # Check if the layer has properties such as 'locked' or 'hidden' that would make it ineligible
    locked = self.locked # Assuming 'locked' is an attribute of Layer
    hidden = self.hidden # Assuming 'hidden' is an attribute of Layer

    if locked || hidden # If the layer is locked or hidden, it is not eligible
      raise Exceptions::LayerIneligibleError.new(I18n.t('common.layer_not_eligible'))
    else
      true
    end
  end
end
