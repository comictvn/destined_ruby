
# typed: strict
class Style < ApplicationRecord
  belongs_to :ui_component, foreign_key: 'ui_component_id'
  has_many :color_themes, foreign_key: 'style_id', dependent: :destroy

  validates :name, presence: true
end
