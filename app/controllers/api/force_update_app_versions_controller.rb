class Api::ForceUpdateAppVersionsController < Api::BaseController
  def index
    # inside service params are checked and whiteisted
    @force_update_app_versions = ForceUpdateAppVersionService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @force_update_app_versions.total_pages
    # Render the response using the 'index.json.jbuilder' view
    render 'index.json.jbuilder', locals: { force_update_app_versions: @force_update_app_versions }
  end
end
