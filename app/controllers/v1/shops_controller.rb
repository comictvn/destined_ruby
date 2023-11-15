class V1::ShopsController < ApplicationController
  before_action :set_shop, only: [:update]
  before_action :authorize_user, only: [:update]
  def update
    if @shop.update(shop_params)
      UserMailer.send_confirmation_email(current_user, @shop).deliver_now
      render json: @shop, status: :ok
    else
      render json: { error: @shop.errors.full_messages }, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end
  private
  def set_shop
    @shop = Shop.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Shop not found' }, status: :not_found
  end
  def shop_params
    params.require(:shop).permit(:name, :address)
  end
  def authorize_user
    unless ShopPolicy.new(current_user, @shop).update?
      render json: { error: 'You are not authorized to perform this action' }, status: :forbidden
    end
  end
end
