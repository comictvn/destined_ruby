# PATH: /app/services/shop_service/update.rb
# rubocop:disable Style/ClassAndModuleChildren
class ShopService::Update
  class ShopNotFound < StandardError; end
  class InvalidShopInformation < StandardError; end
  class ShopUpdateFailed < StandardError; end
  attr_accessor :user, :shop_id, :shop_params
  def initialize(user, shop_id, shop_params)
    @user = user
    @shop_id = shop_id
    @shop_params = shop_params
  end
  def call
    update_shop
  end
  private
  def update_shop
    begin
      # Check if the user has the necessary permissions
      authorize(user, :update?)
      # Find the shop
      shop = Shop.find_by(id: shop_id)
      # If the shop does not exist, raise a custom exception
      raise ShopNotFound, 'This shop is not found' unless shop
      # Validate the new shop information
      validate_shop_information
      # If the information is valid, update the shop's name and address
      if shop.update(shop_params)
        # If the update is successful, return the updated shop
        return { status: 200, shop: shop.as_json }
      else
        # If there is any other error, raise a custom exception
        raise ShopUpdateFailed, 'Shop update failed'
      end
    rescue => e
      # Handle exceptions properly
      return { success: false, message: e.message }
    end
  end
  def validate_shop_information
    raise InvalidShopInformation, 'The name is required.' if shop_params[:name].blank?
    raise InvalidShopInformation, 'You cannot input more 100 characters.' if shop_params[:name].length > 100
    raise InvalidShopInformation, 'You cannot input more 200 characters.' if shop_params[:address].length > 200
  end
  def authorize(user, action)
    ApplicationPolicy.new(user, Shop).public_send(action)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
