class Api::ShopsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[update]
  before_action :set_shop, only: %i[update]
  before_action :validate_shop_owner, only: %i[update]
  before_action :validate_params, only: %i[update]
  def update
    if @shop.update(name: params[:name], address: params[:address])
      render json: { status: 200, shop: @shop }, status: :ok
    else
      render json: { error: 'Failed to update shop' }, status: :unprocessable_entity
    end
  end
  private
  def set_shop
    @shop = Shop.find_by_id(params[:id])
    render json: { error: 'This shop is not found' }, status: :not_found if @shop.nil?
  end
  def validate_shop_owner
    render json: { error: 'Unauthorized' }, status: :unauthorized if current_resource_owner != @shop.owner
  end
  def validate_params
    render json: { error: 'Wrong format' }, status: :bad_request unless params[:id].is_a?(Integer)
    render json: { error: 'The name is required.' }, status: :bad_request if params[:name].blank?
    render json: { error: 'You cannot input more 100 characters.' }, status: :bad_request if params[:name].length > 100
    render json: { error: 'You cannot input more 200 characters.' }, status: :bad_request if params[:address].length > 200
  end
end
