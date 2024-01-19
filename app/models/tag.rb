class Tag < ApplicationRecord
  # Associations
  has_many :article_tags, dependent: :destroy

  # Validations
  validates :name, presence: true, uniqueness: true, length: { maximum: 255 }
end
