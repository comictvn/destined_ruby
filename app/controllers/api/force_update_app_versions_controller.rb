class Api::ForceUpdateAppVersionsController < Api::BaseController
  def index
    # inside service params are checked and whiteisted
    @force_update_app_versions = ForceUpdateAppVersionService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @force_update_app_versions.total_pages
  end

  def create
    force_update_app_version = ForceUpdateAppVersion.new(force_update_app_version_params)
    if force_update_app_version.save
      render json: { status: I18n.t('common.201'), force_update_app_version: force_update_app_version }, status: :created
    else
      render json: { errors: force_update_app_version.errors.full_messages }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def force_update_app_version_params
    params.require(:force_update_app_version).permit(:platform, :force_update, :version, :reason)
  end
end
