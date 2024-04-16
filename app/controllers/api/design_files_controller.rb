
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
      color_style = ColorStyle.new(color_style_params)
      color_style_service = ColorStyleCreationService.new(
        name: color_style_params[:name],
        color_code: color_style_params[:color_code],
        design_file_id: color_style_params[:design_file_id]
      )
      color_style = color_style_service.handle_group_association(color_style)

      if color_style.save
        render json: color_style, status: :created
      else
        render json: color_style.errors, status: :unprocessable_entity
      end
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

    def can_modify_design_file?(design_file)
      # Placeholder for actual access level check
      # This should contain the logic to check if the user has the necessary permissions to modify the design file
    end
  end
end
