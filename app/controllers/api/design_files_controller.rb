
# typed: ignore
module Api
  class DesignFilesController < BaseController
    before_action :authenticate_user!
    rescue_from Exceptions::LayerIneligibleError, with: :render_layer_ineligible_error
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_error
    rescue_from Exceptions::UnauthorizedAccess, with: :render_unauthorized_access_error

    def display_color_styles_icon
      fileId = params[:fileId]
      layerId = params[:layerId]

      begin
        design_file = DesignFile.find(fileId)
        # Check if the user has access to the design file
        raise Exceptions::UnauthorizedAccess unless design_file.access_level == 'public' # Assuming 'public' is a valid access level

        layer = design_file.layers.find(layerId)
        layer.eligible_for_color_styles? # This will raise an exception if the layer is not eligible

        render json: { status: 200, displayColorStyleIcon: true }, status: :ok
      rescue Exceptions::LayerIneligibleError => exception
        render_layer_ineligible_error(exception)
      rescue ActiveRecord::RecordNotFound => exception
        render_not_found_error(exception)
      end
    end

    # ... other actions ...

    private

    def render_layer_ineligible_error(exception)
      render json: { status: 422, message: exception.message }, status: :unprocessable_entity
    end

    def render_not_found_error(exception)
      message = exception.model == 'DesignFile' ? I18n.t('design_files.color_styles.not_found') : I18n.t('common.404')
      render json: { status: 404, message: message }, status: :not_found
    end

    def render_unauthorized_access_error(exception)
      render json: { status: 403, message: exception.message }, status: :forbidden
    end

    def render_error(exception)
      render json: { status: 422, message: exception.message }, status: :unprocessable_entity
    end
  end
end

# Assuming the Layer model and Exceptions module are defined elsewhere in the application:
# app/models/layer.rb
class Layer < ApplicationRecord
  # ... other code ...

  def eligible_for_color_styles?
    # Placeholder for actual eligibility logic
    # If not eligible, raise an exception
    raise Exceptions::LayerIneligibleError, "Layer is not eligible for color styles" unless true
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

  def initialize(name, color_code, design_file_id, user)
    @name = name
    @color_code = color_code
    @design_file_id = design_file_id
    @user = user
  end

  def call
    # Placeholder for the actual implementation logic
    # This should create a color style and return the created object
  end
end
