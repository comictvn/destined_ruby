class Api::ShopsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[update]
  def update
    begin
      params.require(:id)
      params.require(:name)
      params.require(:address)
      @shop = Shop.find_by(id: params[:id])
      return render json: { error: 'Shop not found' }, status: :not_found unless @shop
      authorize @shop, policy_class: Api::ShopsPolicy
      if @shop.update_attributes(name: params[:name], address: params[:address])
        render json: { success: 'Shop updated successfully', shop_id: @shop.id, shop: @shop }, status: :ok
      else
        render json: { error: @shop.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    rescue ActionController::ParameterMissing => e
      render json: { error: e.message }, status: :bad_request
    rescue Pundit::NotAuthorizedError
      render json: { error: 'You are not authorized to perform this action' }, status: :forbidden
    rescue => e
      render json: { error: 'Something went wrong' }, status: :internal_server_error
    end
  end
end
