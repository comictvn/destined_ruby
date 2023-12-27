class Api::ForceUpdateAppVersionsController < Api::BaseController
  before_action :set_pagination_params, only: [:index]

  def index
    @force_update_app_versions = ForceUpdateAppVersion.all
    filter_params.each do |key, value|
      @force_update_app_versions = @force_update_app_versions.public_send("filter_by_#{key}", value) if value.present?
    end
    @force_update_app_versions = @force_update_app_versions.order(created_at: :desc)
    @force_update_app_versions = @force_update_app_versions.page(params[:page]).per(params[:limit])
    @total_pages = @force_update_app_versions.total_pages

    render json: {
      force_update_app_versions: @force_update_app_versions,
      total_pages: @total_pages
    }
  end

  private

  def filter_params
    params.permit(:platform, :reason, :version, :force_update_status)
  end

  def set_pagination_params
    params[:page] ||= 1
    params[:limit] ||= 25
  end
end
