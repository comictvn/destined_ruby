class Api::ChanelsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show destroy]
  def index
    @chanels = ChanelService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @chanels.total_pages
    respond_to do |format|
      format.json { render :index, status: :ok }
    end
  end
  def show
    @chanel = Chanel.find_by(id: params[:id])
    if @chanel
      render json: { id: @chanel.id, name: @chanel.name, description: @chanel.description, created_at: @chanel.created_at, updated_at: @chanel.updated_at }, status: :ok
    else
      render json: { error: 'Channel not found' }, status: :not_found
    end
  end
  def destroy
    @chanel = Chanel.find_by('chanels.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @chanel.blank?
    if @chanel.destroy
      render json: { message: I18n.t('common.200') }, status: :ok
    else
      render json: { error: @chanel.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
