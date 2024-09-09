module ChannelService
  class Index
    attr_accessor :params, :records, :query

    def initialize(params, _current_user = nil)
      @params = params
      @records = Channel.where(user: _current_user)
    end

    def execute
      order_channels

      paginate_channels
    end

    def order_channels
      return if records.blank?

      @records = records.order('channels.created_at desc')
    end

    def paginate_channels
      @records = Channel.none if records.blank? || records.is_a?(Class)
      @records = records.page(params.dig(:pagination, :page) || 1).per(params.dig(:pagination, :limit) || 20)
    end
  end
end