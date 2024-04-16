
module Api
  class DesignFilesController < BaseController
    before_action :set_design_file, only: [:list_color_styles]

    # GET /design_files/:design_file_id/color_styles
    def list_color_styles
      color_styles = @design_file.color_styles.pluck(:id, :name, :color_code).map do |id, name, color_code|
        { id: id, name: name, color_code: color_code }
      end
      render_response(color_styles, message: I18n.t('design_files.color_styles.list.success'))
    rescue ActiveRecord::RecordNotFound => e
      render_error(I18n.t('design_files.color_styles.list.not_found'), status: :not_found)
    rescue Pundit::NotAuthorizedError => e
      render_error(I18n.t('common.403'), status: :forbidden)
    end

    private

    def set_design_file
      @design_file = DesignFile.find(params[:design_file_id])
      authorize @design_file # Assumes Pundit for authorization
    end
  end
end
