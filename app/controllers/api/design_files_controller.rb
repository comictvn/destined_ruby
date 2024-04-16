
module Api
  class DesignFilesController < BaseController
    before_action :set_design_file, only: [:list_color_styles]

    # GET /design_files/:design_file_id/color_styles
    def list_color_styles
      color_styles = @design_file.color_styles.select(:id, :name, :color_code)
      render_response(color_styles)
    rescue ActiveRecord::RecordNotFound => e
      render_error('not_found', message: e.message, status: :not_found)
    rescue Pundit::NotAuthorizedError => e
      render_error('forbidden', message: e.message, status: :forbidden)
    end

    # POST /design_files/:id/apply_color_style_to_layer
    def apply_color_style_to_layer
      layer = Layer.find(params[:layer_id])
      color_style = ColorStyle.find(params[:color_style_id])

      if layer.design_file_id == color_style.design_file_id
        layer.update!(color_style_id: color_style.id)
        render json: { message: I18n.t('apply_color_style_to_layer.success'), layer_id: layer.id, color_style_id: color_style.id }, status: :ok
      else
        render json: { error: I18n.t('apply_color_style_to_layer.error.mismatch') }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: I18n.t('apply_color_style_to_layer.error.not_found') }, status: :not_found
    end

    private

    def set_design_file
      @design_file = DesignFile.find(params[:design_file_id])
      authorize @design_file
    end
  end
end
