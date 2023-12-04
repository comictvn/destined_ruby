class Api::ChanelsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show destroy]
  def index
    @chanels = Chanel.all
    render json: @chanels, only: [:id, :name, :description, :created_at, :updated_at], status: :ok
  end
  def show
    @chanel = Chanel.find(params[:id])
    render json: @chanel
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
