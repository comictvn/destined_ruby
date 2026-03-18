class Api::ForceUpdateAppVersionsController < Api::BaseController
  def index
    begin
      # inside service params are checked and whitelisted
      @force_update_app_versions = ForceUpdateAppVersionService::Index.new(params.permit!, current_resource_owner).execute
      @total_pages = @force_update_app_versions.total_pages
      render_response({ total_pages: @total_pages, force_update_app_versions: @force_update_app_versions })
    rescue => e
      render_error(e.message, status: :unprocessable_entity)
    end
  end

  private

  def current_resource_owner
    # Method to return the current authenticated user (resource owner)
  end
end
