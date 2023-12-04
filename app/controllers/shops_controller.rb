class ShopsController < ApplicationController
  before_action :set_shop, only: [:update]
  def update
    authorize @shop, policy_class: ApplicationPolicy
    validator = ShopValidator.new(shop_params)
    if validator.valid?
      if @shop.update_attributes(shop_params)
        render 'v1/me/put_me.json.jbuilder', status: :ok
      else
        render json: { error: 'Failed to update shop' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid input fields' }, status: :unprocessable_entity
    end
  end
  private
  def set_shop
    @shop = Shop.find_by_id(params[:id])
    if @shop.nil?
      render json: { error: 'Shop not found' }, status: :not_found
    end
  end
  def shop_params
    params.require(:shop).permit(:name, :address)
  end
end
