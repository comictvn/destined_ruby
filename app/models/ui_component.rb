
# typed: strict
class UiComponent < ApplicationRecord
+  has_many :styles, foreign_key: 'ui_component_id', dependent: :destroy
+
+  validates :name, presence: true
end
