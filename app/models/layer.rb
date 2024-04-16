
# typed: strict
class Layer < ApplicationRecord
  belongs_to :design_file
  has_many :color_styles

  validates :name, presence: true
  validates :design_file_id, presence: true

  # Determines if the layer is eligible for color style application
  def eligible_for_color_styles?
    # Assuming 'locked' and 'hidden' are attributes of Layer
    # Replace with actual attribute checks if different
    if self.locked || self.hidden
      # Raise a custom exception with a translated error message
      raise Exceptions::LayerIneligibleError.new(I18n.t('controller.layers.layer_not_eligible'))
    else
      true
    end
  end
end
