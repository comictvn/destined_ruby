module ChanelService
  class Delete
    def initialize(chanel_id, id)
      @chanel_id = chanel_id
      @id = id
    end
    def call
      chanel = Chanel.find_by(id: @chanel_id)
      raise 'Chanel not found' unless chanel
      message = Message.find_by(id: @id, chanel_id: @chanel_id)
      raise 'Message not found' unless message
      message.destroy
      { success: 'Message deleted successfully' }
    end
  end
end
