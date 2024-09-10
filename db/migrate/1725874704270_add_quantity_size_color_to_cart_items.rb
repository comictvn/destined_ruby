class AddQuantitySizeColorToCartItems < ActiveRecord::Migration[6.0]
  def change
    add_column :cart_items, :quantity, :integer, null: false
    add_column :cart_items, :size, :string, null: false
    add_column :cart_items, :color, :string, null: false
  end
end