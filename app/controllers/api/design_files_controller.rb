
module Api
  class DesignFilesController < BaseController
    before_action :set_design_file, only: [:list_color_styles]
    before_action :set_layer_and_color_style, only: [:apply_color_style_to_layer]
    rescue_from ActiveRecord::RecordNotFound, with: :design_file_not_found
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
      result = service.call
      render_response({ group_id: result[:group_id], color_style_ids: result[:color_style_ids] }, :created)
    rescue Exceptions::DesignFileNotFoundError
      render_error('not_found', message: I18n.t('design_files.color_styles.not_found'), status: :not_found)
    rescue Exceptions::GroupCreationError => e
      render_error('group_creation_error', message: e.message, status: :unprocessable_entity)
    rescue Exceptions::GroupAssociationError => e
      render_error('group_association_error', message: e.message, status: :unprocessable_entity)
    rescue Exceptions::InvalidGroupNameError => e
      render_error('invalid_group_name', message: e.message, status: :unprocessable_entity)
    rescue Exceptions::BadRequest => e
      render_error('bad_request', message: e.message, status: :unprocessable_entity)
    end

    # PUT /design_files/:design_file_id/layers/:layer_id/color_styles/:color_style_id
    def apply_color_style_to_layer
      if @layer.design_file_id != @color_style.design_file_id
        render_error('forbidden', message: I18n.t('layers.apply_color_style_to_layer.layer_not_found_or_mismatch'), status: :forbidden)
      else
        @layer.update!(color_style_id: @color_style.id)
        render_response({ layer_id: @layer.id, color_style_id: @color_style.id }, message: I18n.t('layers.apply_color_style_to_layer.success'))
      end
    rescue ActiveRecord::RecordInvalid => e
      render_error('unprocessable_entity', message: e.record.errors.full_messages, status: :unprocessable_entity)
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
    rescue ActiveRecord::RecordNotFound => e
      render_error('not_found', message: I18n.t('design_files.color_styles.list.not_found'), status: :not_found)
    rescue Pundit::NotAuthorizedError => e
      render_error('forbidden', message: I18n.t('design_files.color_styles.list.access_denied'), status: :forbidden)
    end

    end

    def set_layer_and_color_style
      @layer = Layer.find_by(id: params[:layer_id])
      @color_style = ColorStyle.find_by(id: params[:color_style_id])
      unless @layer && @color_style
        missing_record = @layer.nil? ? 'layer' : 'color_style'
        render_error('not_found', message: I18n.t("layers.apply_color_style_to_layer.#{missing_record}_not_found"), status: :not_found)
      end
    end

    def design_file_not_found
      render_error('not_found', message: I18n.t('design_files.color_styles.not_found'), status: :not_found)
    end
  end
end
