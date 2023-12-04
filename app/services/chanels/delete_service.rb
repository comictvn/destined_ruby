class Chanels::DeleteService < BaseService
  def initialize(chanel_id)
    @chanel_id = chanel_id
  end
  def call
    chanel = Chanel.find_by(id: @chanel_id)
    if chanel
      chanel.destroy
      { status: :success, message: 'Chanel deleted successfully' }
    else
      { status: :error, message: 'Chanel not found' }
    end
  rescue => e
    logger.error e.message
    { status: :error, message: 'An error occurred while deleting the chanel' }
  end
end
