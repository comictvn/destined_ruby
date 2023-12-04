class Api::ShopsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_shop, only: [:update]
  before_action :check_owner, only: [:update]
  def update
    if @shop.update(shop_params)
      render json: { status: 200, shop: @shop }
    else
      render json: { status: 'ERROR', message: 'Not updated', data: @shop.errors }, status: :unprocessable_entity
    end
  end
  private
  def set_shop
    @shop = Shop.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { status: 'ERROR', message: 'This shop is not found' }, status: :not_found
  end
  def check_owner
    head(:forbidden) unless @shop.owner == current_user
  end
  def shop_params
    params.require(:shop).permit(:name, :address)
  end
end
