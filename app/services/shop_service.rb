class ShopService
  def initialize(id, name, address)
    @shop = Shop.find_by(id: id)
    @name = name
    @address = address
  end
  def update_shop
    return { status: :error, message: 'Shop does not exist' } unless @shop
    begin
      validate_input
      @shop.update(name: @name, address: @address)
      { status: :success, message: 'Shop updated successfully' }
    rescue StandardError => e
      { status: :error, message: e.message }
    end
  end
  private
  def validate_input
    raise StandardError.new('Name is required') if @name.blank?
    raise StandardError.new('Address is required') if @address.blank?
  end
end
