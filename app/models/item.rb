# typed: strict
class Item < ApplicationRecord
  belongs_to :collection
  has_many :customizations

  has_many :cart_items
  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :discounted_price, numericality: { greater_than_or_equal_to: 0 }
  validates :collection_id, presence: true
end