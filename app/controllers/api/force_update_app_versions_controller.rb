class Api::ForceUpdateAppVersionsController < Api::BaseController
  def index
    service = ForceUpdateAppVersionService::Index.new(params.permit!, current_resource_owner)
    @force_update_app_versions = service.execute
    @total_pages = @force_update_app_versions.total_pages if @force_update_app_versions.respond_to?(:total_pages)

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

  def update
    force_update_app_version = ForceUpdateAppVersion.find(params[:id])
    if force_update_app_version.update(force_update_app_version_params)
      render json: { status: 200, message: I18n.t('force_update_app_versions.update.success'), force_update_app_version: force_update_app_version.as_json }, status: :ok
    else
      render_error(I18n.t('force_update_app_versions.update.unprocessable_entity'), :unprocessable_entity, force_update_app_version.errors.full_messages)
    end
  rescue ActiveRecord::RecordNotFound
    render_error(I18n.t('force_update_app_versions.update.not_found'), :not_found)
  end

  def destroy
    force_update_app_version = ForceUpdateAppVersion.find(params[:id])
    if force_update_app_version.destroy
      render_response({ message: I18n.t('force_update_app_versions.delete.success') }, status: :ok)
    else
      render_error({ message: force_update_app_version.errors.full_messages.to_sentence }, status: :unprocessable_entity)
    end
  rescue ActiveRecord::RecordNotFound => e
    render_error({ message: I18n.t('force_update_app_versions.delete.not_found') }, status: :not_found)
  end

  private

  def force_update_app_version_params
    params.permit(:platform, :force_update, :version, :reason)
  end
end
