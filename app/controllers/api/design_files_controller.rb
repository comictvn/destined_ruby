
class Api::DesignFilesController < Api::BaseController
  before_action :doorkeeper_authorize!

  def list_color_styles
    fileId = params[:file_id]
    design_file = DesignFile.find_by!(id: fileId)
    color_styles = design_file.color_styles.select(:name, :color_code)

    render json: {
      color_styles: color_styles,
      message: I18n.t('design_files.list_color_styles.success')
    }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    raise DesignFileNotFound
  end

  def apply_color_style
    fileId = params[:file_id]
    layerId = params[:layer_id]
    colorStyleId = params[:color_style_id]

    design_file = DesignFile.find_by!(id: fileId)
    layer = design_file.layers.find_by!(id: layerId)
    color_style = design_file.color_styles.find_by!(id: colorStyleId)

    layer.color_styles << color_style

    render json: {
      message: I18n.t('design_files.color_style_apply_success')
    }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: {
      message: I18n.t('common.404')
    }, status: :not_found
  rescue StandardError => e
    render json: {
      message: I18n.t('design_files.color_style_apply_error')
    }, status: :unprocessable_entity
  end
end
