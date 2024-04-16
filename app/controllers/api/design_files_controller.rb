
# typed: ignore
module Api
  class DesignFilesController < BaseController
    before_action :authenticate_user!
    before_action :set_design_file_and_layer, only: [:apply_color_style_to_layer]
    rescue_from Exceptions::LayerIneligibleError, with: :render_layer_ineligible_error
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_error
    rescue_from Exceptions::BadRequest, with: :render_bad_request_error

    def display_color_styles_icon
      fileId = params[:fileId]
      layerId = params[:layerId]

      begin
        design_file = DesignFile.find(fileId)
        layer = design_file.layers.find_by!(id: layerId)
        if layer.eligible_for_color_styles?
          render json: { display_icon: true, message: I18n.t('design_files.layers.display_color_styles_icon.success') }, status: :ok
        end
      rescue Exceptions::LayerIneligibleError => exception
        render_layer_ineligible_error(exception)
      rescue ActiveRecord::RecordNotFound => exception
        render_not_found_error(exception)
      end
    end

    # PATCH /design-files/:fileId/layers/:layerId/color-styles/:colorStyleId
    def apply_color_style_to_layer
      color_style_id = params[:colorStyleId]

      # Validate that the color_style_id exists in the color_styles table
      color_style = ColorStyle.find_by(id: color_style_id)
      raise Exceptions::BadRequest, I18n.t('design_files.layers.apply_color_style.color_style_not_found') unless color_style

      # Check if the layer is associated with the same design file as the color style
      raise Exceptions::BadRequest, I18n.t('design_files.layers.apply_color_style.bad_request') unless @layer.design_file_id == color_style.design_file_id

      # Update the layer's record in the layers table to reference the color_style_id
      @layer.update!(color_style_id: color_style_id)

      # Placeholder for undo/redo functionality
      # TODO: Implement undo/redo functionality

      # Return a confirmation of the color style application to the layer
      render json: {
        status: 200,
        layer: {
          id: @layer.id,
          fileId: @layer.design_file_id,
          colorStyleId: color_style_id,
          updatedAt: @layer.updated_at.iso8601
        }
      }, status: :ok
    end

    # ... other actions ...

    private

    def set_design_file_and_layer
      @design_file = DesignFile.find(params[:fileId])
      @layer = @design_file.layers.find(params[:layerId])
    end

    def render_layer_ineligible_error(exception)
      render json: { message: I18n.t('design_files.layers.display_color_styles_icon.layer_ineligible') }, status: :unprocessable_entity
    end

    def render_not_found_error(exception)
      message = exception.model == 'DesignFile' ? I18n.t('design_files.color_styles.not_found') : I18n.t('common.404')
      render json: { message: message }, status: :not_found
    end

    def render_bad_request_error(exception)
      render json: { message: exception.message }, status: :bad_request
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
