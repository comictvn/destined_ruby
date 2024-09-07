module Api
class ChanelsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show destroy]

  def index
    # inside service params are checked and whiteisted
    @chanels = ChanelService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @chanels.total_pages
  end

  def show
    @chanel = Chanel.find_by!('chanels.id = ?', params[:id])
  end

  def destroy
    @chanel = Chanel.find_by('chanels.id = ?', params[:id])

    raise ActiveRecord::RecordNotFound if @chanel.blank?

    if @chanel.destroy
      head :ok, message: I18n.t('common.200')
    else
      head :unprocessable_entity
    end
  end
end
end