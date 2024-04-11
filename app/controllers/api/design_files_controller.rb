
class Api::DesignFilesController < Api::BaseController
  before_action :doorkeeper_authorize!

  def display_color_styles_icon
    file_id = params[:file_id]
    layer_id = params[:layer_id]
    design_file = DesignFile.find(file_id)
    layer = design_file.layers.find(layer_id)

    is_eligible = !layer.locked && !layer.hidden
    message_key = is_eligible ? 'color_styles_icon_display_eligible' : 'color_styles_icon_display_ineligible'

    render_response({ display_color_styles_icon: is_eligible }, message: I18n.t("common.#{message_key}"))
  rescue ActiveRecord::RecordNotFound => e
    raise Exceptions::DesignFileNotFound, I18n.t('common.design_file_not_found') if e.model == 'DesignFile'
    raise Exceptions::LayerNotFound, I18n.t('common.layer_not_found')
  end

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
end
