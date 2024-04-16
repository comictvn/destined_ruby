
module Api
  class DesignFilesController < BaseController
    before_action :set_design_file, only: [:list_color_styles]
    rescue_from Exceptions::DesignFileNotFoundError, with: :design_file_not_found

    # GET /design_files/:design_file_id/color_styles
    def list_color_styles
      color_styles = @design_file.color_styles.select(:id, :name, :color_code)
      render_response(color_styles)
    end

    # POST /design_files/:design_file_id/color_styles
    def create_color_style
      validate_color_style_params
      design_file = DesignFile.find_by(id: params[:design_file_id])
      raise Exceptions::DesignFileNotFoundError unless design_file && can_modify_design_file?(design_file)

      color_style = design_file.color_styles.create!(color_style_params)
      render_response(color_style, :created)
    end

    private

    # PATCH /design_files/apply_color_style_to_layer
    def apply_color_style_to_layer
      layer = Layer.find(params[:layer_id])
      color_style = ColorStyle.find(params[:color_style_id])

      raise Exceptions::DesignFileNotFoundError unless layer.design_file_id == color_style.design_file_id

      layer.update!(color_style: color_style)

      # TODO: Implement undo/redo functionality

      render_response({ layer_id: layer.id, color_style_id: color_style.id })
    rescue ActiveRecord::RecordNotFound => e
      render_error('not_found', message: e.message, status: :not_found)
    rescue Exceptions::DesignFileNotFoundError => e
      render_error('design_file_not_found', message: I18n.t('design_files.color_styles.layer_not_found_or_mismatch'), status: :not_found)
    end

    # Other private methods...

    def validate_color_style_params
      params.require(:name)
      params.require(:color_code)
      params.require(:design_file_id)
    end

    def color_style_params
      params.permit(:name, :color_code, :design_file_id)
    end

    def set_design_file
      @design_file = DesignFile.find(params[:design_file_id])
      authorize @design_file
    rescue ActiveRecord::RecordNotFound => e
      render_error('not_found', message: e.message, status: :not_found)
    rescue Pundit::NotAuthorizedError => e
      render_error('forbidden', message: e.message, status: :forbidden)
    end

    def design_file_not_found
      render_error('not_found', message: I18n.t('design_files.color_styles.not_found'), status: :not_found)
    end

    def can_modify_design_file?(design_file)
      # Placeholder for actual access level check
      # This should contain the logic to check if the user has the necessary permissions to modify the design file
    end
  end
end
