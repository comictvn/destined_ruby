
# typed: ignore
module Api
  class DesignFilesController < BaseController
    before_action :authenticate_user!
    rescue_from Exceptions::LayerIneligibleError, with: :render_layer_ineligible_error
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_error

    def display_color_styles_icon
      fileId = params[:fileId]
      layerId = params[:layerId]

      begin
        design_file = DesignFile.find(fileId)
        layer = design_file.layers.find(layerId)
        if layer.eligible_for_color_styles?
          render_response({ display_color_styles_icon: true }, message: I18n.t('design_files.layers.display_color_styles_icon.success'))
        end
      rescue Exceptions::LayerIneligibleError => e
        render_layer_ineligible_error(e)
      rescue ActiveRecord::RecordNotFound => e
        render_error('server_error', message: e.message, status: :internal_server_error)
      end
    end

    def list_color_styles
      fileId = params[:fileId]

      begin
        design_file = current_user.design_files.find(fileId)
        color_styles = design_file.color_styles.select(:id, :name, :color_code)

        render_response({ status: 200, colorStyles: color_styles })
      rescue => e
        render_error('server_error', message: I18n.t('common.errors.server_error'), status: :internal_server_error)
      end
    end

    def apply_color_style_to_layer
      # Ensure the route is correctly defined in /config/routes.rb
      fileId = params[:fileId]
      layerId = params[:layerId]
      colorStyleId = params[:colorStyleId]

      begin
        design_file = DesignFile.find(fileId)
        layer = design_file.layers.find(layerId)
        color_style = ColorStyle.find(colorStyleId)

        # Check if the layer and color style belong to the same design file
        raise Exceptions::BadRequest, I18n.t('design_files.layers.apply_color_style.bad_request') unless design_file.id == color_style.design_file_id

        if layer.eligible_for_color_styles?
          layer.update!(color_style_id: colorStyleId)
        end

        render_response({ status: 200, layer: layer.as_json.merge(colorStyleId: colorStyleId) }, message: I18n.t('design_files.layers.apply_color_style.success'))
      rescue Exceptions::BadRequest, ActiveRecord::RecordNotFound => e
        render_error('bad_request', message: e.message, status: :bad_request)
      rescue ActiveRecord::RecordInvalid => e
        render_error('unprocessable_entity', message: e.record.errors.full_messages, status: :unprocessable_entity)
      end
    end

    private

    def render_layer_ineligible_error(exception)
      render_error('layer_ineligible', message: I18n.t('controller.layer_not_eligible', default: exception.message), status: :unprocessable_entity)
    end

    def render_not_found_error(exception)
      render_error('not_found', message: I18n.t('common.404'), status: :not_found)
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
end
