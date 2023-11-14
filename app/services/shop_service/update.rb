# PATH: /app/services/shop_service/update.rb
# rubocop:disable Style/ClassAndModuleChildren
class ShopService::Update
  attr_accessor :shop_id, :name, :address, :current_user
  def initialize(shop_id, name, address, current_user)
    @shop_id = shop_id
    @name = name
    @address = address
    @current_user = current_user
  end
  def call
    validate_input
    shop = Shop.find_by(id: @shop_id)
    raise StandardError, 'This shop is not found' unless shop
    unless ShopsPolicy.new(@current_user, shop).update?
      raise StandardError, 'You do not have permission to update this shop'
    end
    begin
      shop.update!(name: @name, address: @address)
      { message: 'Shop updated successfully', shop: shop }
    rescue StandardError => e
      raise StandardError, 'An unexpected error occurred', message: e.message
    end
  end
  private
  def validate_input
    errors = []
    errors << 'Shop ID is required' if @shop_id.blank?
    errors << 'Shop ID is not a number' unless @shop_id.is_a?(Numeric)
    errors << 'The name is required.' if @name.blank?
    errors << 'You cannot input more 100 characters.' if @name.length > 100
    errors << 'Address is required' if @address.blank?
    errors << 'You cannot input more 200 characters.' if @address.length > 200
    raise StandardError, errors.join(', ') unless errors.empty?
  end
end
# rubocop:enable Style/ClassAndModuleChildren
