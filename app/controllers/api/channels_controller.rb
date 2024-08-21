class Api::ChannelsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show destroy]

  def index
    # ... rest of the index action code ...
  end

  # ... rest of the controller actions and methods ...
end