module ChanelService
  class Delete
    def initialize(id)
      @id = id
    end
    def call
      chanel = Chanel.find_by(id: @id)
      return { error: 'Chanel not found' } unless chanel
      chanel.destroy
      { success: 'Chanel deleted successfully' }
    end
  end
end
