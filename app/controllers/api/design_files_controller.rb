
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

    private

    def set_design_file
      @design_file = DesignFile.find(params[:design_file_id])
      authorize @design_file
    end
  end
end
