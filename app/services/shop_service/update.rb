# rubocop:disable Style/ClassAndModuleChildren
class ShopService::Update
  attr_accessor :id, :name, :address, :user
  def initialize(id, name, address, user)
    @id = id
    @name = name
    @address = address
    @user = user
  end
  def execute
    validate_input
    shop = Shop.find_by(id: @id)
    return { error: 'Shop not found' } unless shop
    return { error: 'User does not have necessary permissions' } unless user_has_permissions?
    shop.update(name: @name, address: @address)
    { success: 'Shop updated successfully', id: shop.id, shop: shop }
  end
  private
  def validate_input
    errors = []
    errors << 'ID is required' if @id.blank?
    errors << 'Name is required' if @name.blank?
    errors << 'Address is required' if @address.blank?
    raise StandardError, errors.join(', ') unless errors.empty?
  end
  def user_has_permissions?
    # Assuming User model has a method `can_update_shop?` that checks if the user has necessary permissions
    @user.can_update_shop?(@id)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
