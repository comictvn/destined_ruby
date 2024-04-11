
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
end
