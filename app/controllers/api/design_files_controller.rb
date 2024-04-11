
class Api::DesignFilesController < Api::BaseController
  before_action :doorkeeper_authorize!

  # GET /api/design_files/:file_id/color_styles
  def list_color_styles
    fileId = params[:file_id]
    design_file = DesignFile.find_by!(id: fileId)
    color_styles = design_file.color_styles.select(:name, :color_code)

    render_response(color_styles, message: I18n.t('design_files.list_color_styles.success'))
  rescue ActiveRecord::RecordNotFound => e
    raise Exceptions::DesignFileNotFound
  end

  # Other controller actions...

  private

  def render_response(resource, message:)
    render json: {
      resource: resource,
      message: message
    }, status: :ok
  end
end
