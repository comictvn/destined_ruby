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
    @chanel = Chanel.find(params[:id])
    render json: @chanel
  end
  def destroy
    @chanel = Chanel.find_by_id(params[:id])
    if @chanel.nil?
      render json: { error: 'Channel not found.' }, status: :not_found
    else
      if @chanel.destroy
        render json: { message: 'Channel was successfully deleted.' }, status: :ok
      else
        render json: { error: @chanel.errors.full_messages }, status: :unprocessable_entity
      end
    end
  rescue => e
    render json: { error: 'An error occurred while trying to delete the channel.' }, status: :internal_server_error
  end
end
