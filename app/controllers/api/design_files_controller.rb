
# typed: ignore
module Api
  class DesignFilesController < BaseController
    before_action :authenticate_user!
    rescue_from Exceptions::LayerIneligibleError, with: :render_layer_ineligible_error
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_error

    def display_color_styles_icon
      file_id = params[:fileId]
      layer_id = params[:layerId]

      begin
        design_file = DesignFile.find(file_id)
        layer = design_file.layers.find(layer_id)
        if layer.eligible_for_color_styles?
          render json: { display_icon: true, message: I18n.t('design_files.layers.display_color_styles_icon.success') }, status: :ok
        end
      rescue Exceptions::LayerIneligibleError => exception
        render_layer_ineligible_error(exception)
      rescue ActiveRecord::RecordNotFound => exception
        render_not_found_error(exception)
      end
    end

    # ... other actions ...

    private

    def render_layer_ineligible_error(exception)
      render json: { message: I18n.t('design_files.layers.display_color_styles_icon.layer_ineligible') }, status: :unprocessable_entity
    end

    def render_not_found_error(exception)
      message = if exception.model == 'DesignFile'
                  I18n.t('design_files.color_styles.not_found')
                else
                  I18n.t('design_files.layers.display_color_styles_icon.layer_not_found')
                end
      render json: { message: message }, status: :not_found
    end
  end
end

# Assuming the Layer model and Exceptions module are defined elsewhere in the application:
# app/models/layer.rb
class Layer < ApplicationRecord
  # ... other code ...

  def eligible_for_color_styles?
    # Placeholder for actual eligibility logic
    true
  end
end

# app/models/exceptions.rb
module Exceptions
  class LayerIneligibleError < StandardError; end
  class BadRequest < StandardError; end
  class UnauthorizedAccess < StandardError; end # Assuming this is defined as it's used in the patch
end

# Assuming the ColorStyleCreationService is defined elsewhere in the application:
# app/services/color_style_creation_service.rb
class ColorStyleCreationService
  # ... other code ...
end
