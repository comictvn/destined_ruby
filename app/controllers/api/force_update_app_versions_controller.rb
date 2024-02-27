class Api::ForceUpdateAppVersionsController < Api::BaseController
  def index
    # Merged the new service call with the existing one, including the current_resource_owner
    service = ForceUpdateAppVersionService::Index.new(params.permit!, current_resource_owner)
    @force_update_app_versions = service.execute
    @total_pages = @force_update_app_versions.total_pages if @force_update_app_versions.respond_to?(:total_pages)

    # Combined the new and existing response handling
    if @force_update_app_versions.present?
      render_response(@force_update_app_versions)
    else
      render_error({ message: I18n.t('force_update_app_versions.index.not_found') }, status: :not_found)
    end
  end

  def create
    force_update_app_version = ForceUpdateAppVersion.new(force_update_app_version_params)
    if force_update_app_version.save
      render json: { status: I18n.t('common.created'), force_update_app_version: force_update_app_version }, status: :created
    else
      render json: { errors: force_update_app_version.errors.full_messages }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def destroy
    force_update_app_version = ForceUpdateAppVersion.find(params[:id])
    force_update_app_version.destroy
    render_response({ message: I18n.t('force_update_app_versions.delete.success') }, status: :ok)
  rescue ActiveRecord::RecordNotFound => e
    render_error({ message: I18n.t('force_update_app_versions.delete.not_found') }, status: :not_found)
  end

  private

  def force_update_app_version_params
    params.require(:force_update_app_version).permit(:platform, :force_update, :version, :reason)
  end
end
