class Api::V1::ShopsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_shop, only: [:update]
  before_action :authorize_user, only: [:update]
  def update
    begin
      shop_params = params.permit(:id, :name, :address)
      result = ShopValidator.new(shop_params).validate
      if result[:status] == :error
        render json: { error: result[:message] }, status: :unprocessable_entity
      else
        shop = ShopService.new(shop_params).update
        if shop[:status] == :error
          render json: { error: shop[:message] }, status: :unprocessable_entity
        else
          UserMailer.shop_update_confirmation(current_user, shop[:data]).deliver_now
          render json: { status: 200, message: 'Shop updated successfully.', shop: shop[:data] }, status: :ok
        end
      end
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
  private
  def set_shop
    @shop = Shop.find_by(id: params[:id])
    return render json: { error: 'This shop is not found' }, status: :not_found unless @shop
  end
  def authorize_user
    unless ShopPolicy.new(current_user, @shop).update?
      render json: { error: 'You are not authorized to update this shop.' }, status: :forbidden
    end
  end
end
