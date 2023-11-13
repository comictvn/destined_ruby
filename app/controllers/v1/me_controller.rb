class V1::MeController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index put_me]

  def index
    # inside service params are checked and whiteisted
    @users = UserService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @users.total_pages
  end
end
