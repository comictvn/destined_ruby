
class Api::DesignFilesController < Api::BaseController
  before_action :doorkeeper_authorize!

  def create_color_style
    validate_color_style_params
    design_file = DesignFile.find_by!(id: params[:fileId])
    color_style = ColorStyle.create!(name: params[:name], color_code: params[:color_code], design_file_id: params[:fileId])
    render_response({ id: color_style.id }, I18n.t('color_style.create.success'))
  rescue ActiveRecord::RecordNotFound
    raise Exceptions::DesignFileNotFound
  rescue ActiveRecord::RecordInvalid => e
    render_error(e.record.errors.full_messages, status: :unprocessable_entity)
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

  private

  def validate_color_style_params
    params.require(:name)
    params.require(:color_code)
  end
end
