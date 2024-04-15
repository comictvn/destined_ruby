
# typed: ignore
module Api
  class DesignFilesController < BaseController
    before_action :authenticate_user!
    rescue_from Exceptions::LayerIneligibleError, with: :base_render_layer_ineligible_error

    def display_color_styles_icon
      begin
        design_file = DesignFile.find(params[:fileId])
        layer = design_file.layers.find(params[:layerId])
        
        # The eligibility check is now performed on the layer instance
        is_eligible = layer.check_layer_eligibility
        
        render_response({ display_color_styles_icon: is_eligible })
      rescue ActiveRecord::RecordNotFound => e
        render_error('not_found', message: I18n.t('common.errors.record_not_found'), status: :not_found)
      rescue => e
        render_error('server_error', message: I18n.t('common.errors.server_error'), status: :internal_server_error)
      end
    end

    private

    def base_render_layer_ineligible_error(exception)
      render_error('layer_ineligible', message: I18n.t('controller.layer_not_eligible', default: exception.message), status: :unprocessable_entity)
    end

    # This method should be defined in the Layer model
    def check_layer_eligibility(layer)
      raise Exceptions::LayerIneligibleError unless layer.eligible_for_color_styles?
    end
  end
end

# Assuming the Layer model and Exceptions module are defined elsewhere in the application:
# app/models/layer.rb
class Layer < ApplicationRecord
  # ... other code ...

  def check_layer_eligibility
    eligible_for_color_styles?
  end

  def eligible_for_color_styles?
    # Placeholder for actual eligibility logic
    true
  end
end

# app/models/exceptions.rb
module Exceptions
  class LayerIneligibleError < StandardError; end
end
