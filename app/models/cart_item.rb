# typed: strict
class CartItem < ApplicationRecord
  belongs_to :item

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :size, presence: true
  validates :color, presence: true
  validates :item_id, presence: true
end