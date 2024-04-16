
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
      service = ColorStyleCreationService.new(
        name: color_style_params[:name],
        color_code: color_style_params[:color_code],
        design_file_id: color_style_params[:design_file_id]
      )
      color_style = service.call
      render_response(color_style, :created)
    rescue Exceptions::DesignFileNotFoundError
      render_error('not_found', message: I18n.t('design_files.color_styles.not_found'), status: :not_found)
    rescue Exceptions::BadRequest => e
      render_error('bad_request', message: e.message, status: :unprocessable_entity)
    end

    private

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
  end
end
