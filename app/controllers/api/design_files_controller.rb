
# typed: ignore
module Api
  require 'exceptions'
  class DesignFilesController < BaseController
    before_action :authenticate_user!
    rescue_from Exceptions::LayerIneligibleError, with: :render_layer_ineligible_error
    rescue_from Exceptions::UnauthorizedAccess, with: :render_unauthorized_access_error

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
    
    def create_color_style
      name = params[:name]
      color_code = params[:color_code]
      file_id = params[:fileId]

      begin
        design_file = DesignFile.find(file_id)
        # Placeholder for user permission check
        # raise Exceptions::UnauthorizedAccess unless user_has_permission?(design_file)

        color_style = design_file.color_styles.create!(name: name, color_code: color_code)
        # Placeholder for group association logic
        # update_or_create_group_association_if_needed(name)

        render json: { status: 201, colorStyle: color_style }, status: :created
      rescue ActiveRecord::RecordNotFound
        render_error('not_found', message: I18n.t('common.errors.record_not_found'), status: :not_found)
      rescue ActiveRecord::RecordInvalid => e
        render_error('unprocessable_entity', message: e.record.errors.full_messages.to_sentence, status: :unprocessable_entity)
      rescue Exceptions::UnauthorizedAccess
        render_error('unauthorized', message: I18n.t('common.errors.unauthorized_error'), status: :unauthorized)
      rescue => e
        render_error('server_error', message: I18n.t('common.errors.server_error'), status: :internal_server_error)
      end
    end

    private

    def render_layer_ineligible_error(exception)
      render_error('layer_ineligible', message: I18n.t('controller.layer_not_eligible', default: exception.message), status: :unprocessable_entity)
    end

    def render_unauthorized_access_error(exception)
      render_error('unauthorized', message: I18n.t('common.errors.unauthorized_error', default: exception.message), status: :unauthorized)
    end

    # Checks if the layer is eligible for color styles
    def check_layer_eligibility(layer)
      raise Exceptions::LayerIneligibleError unless layer.eligible_for_color_styles?
    end
  end
end

# Assuming the DesignFile model and related associations are defined elsewhere in the application:
# app/models/design_file.rb
class DesignFile < ApplicationRecord
  # ... other code ...
  has_many :color_styles
end

# Assuming the ColorStyle model is defined elsewhere in the application:
# app/models/color_style.rb
class ColorStyle < ApplicationRecord
  # ... other code ...
  belongs_to :design_file
  validates :name, presence: true
  validates :color_code, presence: true
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
  class UnauthorizedAccess < StandardError; end
end
