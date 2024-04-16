
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
          render json: { display_icon: true, message: I18n.t('design_files.layers.display_color_styles_icon.icon_displayed') }, status: :ok
        end
      rescue Exceptions::LayerIneligibleError => exception
        render_layer_ineligible_error(exception)
      rescue ActiveRecord::RecordNotFound => exception
        render_not_found_error(exception)
      end
    end

    def create_color_style
      fileId = params[:fileId]
      name = params[:name]
      color_code = params[:color_code]

      begin
        color_style = ColorStyleCreationService.new(name, color_code, fileId, current_user).call
        render json: { status: 201, colorStyle: { id: color_style.id, name: color_style.name, color_code: color_style.color_code, design_file_id: color_style.design_file_id } }, status: :created
      rescue StandardError => e
        render_error(e)
      end
    end

    # ... other actions ...

    private

    def render_layer_ineligible_error(exception)
      render json: { message: exception.message }, status: :unprocessable_entity
    end

    def render_not_found_error(exception)
      message = exception.model == 'DesignFile' ? I18n.t('design_files.color_styles.not_found') : I18n.t('common.404')
      render json: { message: message }, status: :not_found
    end

    def render_error(exception)
      render json: { message: exception.message }, status: :unprocessable_entity
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
