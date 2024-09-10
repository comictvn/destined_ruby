class Api::ChannelsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show destroy]

  def index
    # inside service params are checked and whiteisted
    @channels = ChannelService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @channels.total_pages
  end

  def show
    # show action code remains unchanged
  end

  # rest of the controller code remains unchanged
end