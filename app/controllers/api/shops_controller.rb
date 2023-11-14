class Api::ShopsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[update]
  def update
    begin
      params.require(:shop_id)
      params.require(:name)
      params.require(:address)
      raise ActionController::BadRequest.new("Wrong format") unless params[:shop_id].is_a? Integer
      raise ActionController::BadRequest.new("The name is required.") if params[:name].blank?
      raise ActionController::BadRequest.new("You cannot input more 100 characters.") if params[:name].length > 100
      raise ActionController::BadRequest.new("You cannot input more 200 characters.") if params[:address].length > 200
      @shop = Shop.find_by(id: params[:shop_id])
      return render json: { error: 'This shop is not found' }, status: :not_found unless @shop
      authorize @shop, policy_class: Api::ShopsPolicy
      result = ShopService::Update.new(@shop, params[:name], params[:address], current_user).call
      if result.success?
        render json: { status: 200, shop: @shop }, status: :ok
      else
        render json: { error: result.errors.full_messages.join(', ') }, status: :unprocessable_entity
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
