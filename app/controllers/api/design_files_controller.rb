
# typed: ignore
module Api
  class DesignFilesController < BaseController
    before_action :authenticate_user!
    rescue_from Exceptions::LayerIneligibleError, with: :render_layer_ineligible_error

    def display_color_styles_icon
      fileId = params[:fileId]
      layerId = params[:layerId]

      begin
        design_file = DesignFile.find(fileId)
        layer = design_file.layers.find(layerId)
        
        # Checks if the layer is eligible for color styles
        check_layer_eligibility(layer)
        
        render_response({ display_color_styles_icon: true }, message: I18n.t('controller.display_color_styles_icon'))
      rescue ActiveRecord::RecordNotFound => e
        render_error('not_found', message: I18n.t('common.errors.record_not_found'), status: :not_found)
      rescue => e
        render_error('server_error', message: I18n.t('common.errors.server_error'), status: :internal_server_error)
      end
    end

    def list_color_styles
      fileId = params[:fileId]

      begin
        design_file = DesignFile.find(fileId)
        color_styles = design_file.color_styles.select(:id, :name, :color_code)

        render_response({ status: 200, colorStyles: color_styles })
      rescue ActiveRecord::RecordNotFound => e
        render_error('not_found', message: I18n.t('design_files.color_styles.not_found'), status: :not_found)
      rescue => e
        render_error('server_error', message: I18n.t('common.errors.server_error'), status: :internal_server_error)
      end
    end

    def apply_color_style_to_layer
      fileId = params[:fileId]
      layerId = params[:layerId]
      colorStyleId = params[:colorStyleId]

      begin
        design_file = DesignFile.find(fileId)
        layer = design_file.layers.find(layerId)
        color_style = ColorStyle.find(colorStyleId)

        raise Exceptions::BadRequest, I18n.t('design_files.layers.apply_color_style.bad_request') unless design_file.id == color_style.design_file_id

        layer.update!(color_style_id: colorStyleId)

        render_response({ status: 200, layer: layer.as_json.merge(colorStyleId: colorStyleId) }, message: I18n.t('design_files.layers.apply_color_style.success'))
      rescue ActiveRecord::RecordNotFound => e
        render_error('not_found', message: e.message, status: :not_found)
      rescue Exceptions::BadRequest => e
        render_error('bad_request', message: e.message, status: :bad_request)
      rescue ActiveRecord::RecordInvalid => e
        render_error('unprocessable_entity', message: e.record.errors.full_messages, status: :unprocessable_entity)
      end
    end

    private

    def render_layer_ineligible_error(exception)
      render_error('layer_ineligible', message: I18n.t('controller.layer_not_eligible', default: exception.message), status: :unprocessable_entity)
    end

    # Checks if the layer is eligible for color styles
    def check_layer_eligibility(layer)
      raise Exceptions::LayerIneligibleError unless layer.eligible_for_color_styles?
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
end
