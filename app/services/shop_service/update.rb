# PATH: /app/services/shop_service/update.rb
# rubocop:disable Style/ClassAndModuleChildren
class ShopService::Update
  attr_accessor :id, :name, :address
  def initialize(id, name, address)
    @id = id
    @name = name
    @address = address
  end
  def call
    validate_input
    shop = Shop.find_by(id: @id)
    return { error: 'This shop is not found' } unless shop
    begin
      shop.update!(name: @name, address: @address)
      { success: 'Shop updated successfully', id: shop.id, shop: shop }
    rescue StandardError => e
      { error: 'An unexpected error occurred', message: e.message }
    end
  end
  private
  def validate_input
    errors = []
    errors << 'ID is required' if @id.blank?
    errors << 'ID is not a number' unless @id.is_a?(Numeric)
    errors << 'The name is required.' if @name.blank?
    errors << 'You cannot input more 100 characters.' if @name.length > 100
    errors << 'Address is required' if @address.blank?
    errors << 'You cannot input more 200 characters.' if @address.length > 200
    raise StandardError, errors.join(', ') unless errors.empty?
  end
end
# rubocop:enable Style/ClassAndModuleChildren
