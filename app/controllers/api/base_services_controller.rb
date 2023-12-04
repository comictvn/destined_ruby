class Api::BaseServicesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show destroy health_check]
  def index
    @base_services = BaseServiceService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @base_services.total_pages
  end
  def show
    @base_service = BaseService.find_by!('base_services.id = ?', params[:id])
  end
  def destroy
    @base_service = BaseService.find_by('base_services.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @base_service.blank?
    if @base_service.destroy
      head :ok, message: I18n.t('common.200')
    else
      head :unprocessable_entity
    end
  end
  def health_check
    @base_service = BaseService.find_by('base_services.id = ?', params[:id])
    if @base_service.present?
      render json: { health_check: @base_service.health_check }
    else
      render json: { error: "BaseService with id #{params[:id]} does not exist" }, status: :not_found
    end
  end
end
