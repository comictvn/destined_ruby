
module Api
  class DesignFilesController < BaseController
    before_action :set_design_file, only: [:list_color_styles, :group_color_styles]

    # GET /design_files/:design_file_id/color_styles
    def list_color_styles
      color_styles = @design_file.color_styles.select(:id, :name, :color_code)
      render_response(color_styles)
    rescue ActiveRecord::RecordNotFound => e
      render_error('not_found', message: e.message, status: :not_found)
    rescue Pundit::NotAuthorizedError => e
      render_error('forbidden', message: e.message, status: :forbidden)
    end

    # POST /design_files/:design_file_id/group_color_styles
    def group_color_styles
      group_name, color_style_ids = ColorStyle.find_or_create_group(params[:name], @design_file.id)
      if group_name.present?
        render_response({ group_id: group_name, color_style_ids: color_style_ids })
      else
        render_error('group_creation_failed', message: 'Failed to create or find the group', status: :unprocessable_entity)
      end
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
