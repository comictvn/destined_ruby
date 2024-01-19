
class Tag < ApplicationRecord
  # Associations
  has_many :article_tags, dependent: :destroy

  # Validations
  validates :name, presence: true, uniqueness: true, length: { maximum: 255 }

  # Methods
  def self.find_or_create_by_name(tag_name)
    find_or_create_by(name: tag_name)
  end
end
