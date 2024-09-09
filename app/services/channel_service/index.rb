module ChannelService
  class Index
    def initialize(params, user)
      @params = params
      @user = user
    end

    def execute
      Channel.where(user: @user).paginate(@params[:page])
    end
  end
end