
# typed: ignore
module Api
  class DesignFilesController < BaseController
    before_action :authenticate_user!
    before_action :set_design_file, only: [:list_color_styles]
    rescue_from Exceptions::LayerIneligibleError, with: :render_layer_ineligible_error
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_error
    rescue_from Exceptions::UnauthorizedAccess, with: :render_unauthorized_access_error

    def list_color_styles
      begin
        authorize_access_to_design_file!
        color_styles = @design_file.color_styles.select(:id, :name, :color_code)
        render json: { status: 200, colorStyles: color_styles }, status: :ok
      rescue Exceptions::UnauthorizedAccess => exception
        render_unauthorized_access_error(exception)
      end
    end

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

    # ... other actions ...

    private

    def set_design_file
      @design_file = DesignFile.find(params[:fileId])
    end

    def authorize_access_to_design_file!
      raise Exceptions::UnauthorizedAccess unless @design_file.access_level == 'edit'
    end

    def render_layer_ineligible_error(exception)
      render json: { message: I18n.t('design_files.layers.display_color_styles_icon.layer_ineligible') }, status: :unprocessable_entity
    end

    def render_not_found_error(exception)
      message = exception.model == 'DesignFile' ? I18n.t('design_files.color_styles.not_found') : I18n.t('common.404')
      render json: { message: message }, status: :not_found
    end

    def render_unauthorized_access_error(exception)
      render json: { message: I18n.t('common.unauthorized_access') }, status: :unauthorized
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
  class UnauthorizedAccess < StandardError; end
end

# Assuming the ColorStyleCreationService is defined elsewhere in the application:
# app/services/color_style_creation_service.rb
class ColorStyleCreationService
  # ... other code ...
end
