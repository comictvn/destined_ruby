class Api::ChannelsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show destroy]

  def index
    @chanels = Channel.page(params[:page])
    @total_pages = @chanels.total_pages
  end

  def show
    @chanel = Channel.find_by!('channels.id = ?', params[:id])
  end

  def destroy
    @chanel = Channel.find_by('channels.id = ?', params[:id])

    raise ActiveRecord::RecordNotFound if @chanel.blank?
    
    if @chanel.destroy
      head :ok, message: I18n.t('common.200')
    else
      render json: { errors: @chanel.errors.full_messages }, status: :unprocessable_entity
    end
  end
end