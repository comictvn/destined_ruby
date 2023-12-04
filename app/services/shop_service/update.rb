module ShopService
  class Update
    def initialize(id, name, address)
      @id = id
      @name = name
      @address = address
    end
    def call
      raise StandardError.new('Wrong format') unless @id.is_a?(Integer)
      @shop = Shop.find_by(id: @id)
      raise StandardError.new('This shop is not found') unless @shop
      raise StandardError.new('The name is required.') if @name.blank?
      raise StandardError.new('You cannot input more 100 characters.') if @name.length > 100
      raise StandardError.new('You cannot input more 200 characters.') if @address.length > 200
      begin
        @shop.update(name: @name, address: @address)
        { status: 200, shop: { id: @shop.id, name: @shop.name, address: @shop.address } }
      rescue StandardError => e
        { status: :error, message: e.message }
      end
    end
  end
end
