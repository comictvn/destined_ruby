
# typed: strict
class ColorStyle < ApplicationRecord
  belongs_to :design_file
  belongs_to :layer

  validates :name, presence: true
  validates :color_code, presence: true, format: { with: /\A#[0-9A-F]{6}\z/i, message: I18n.t('activerecord.errors.models.color_style.attributes.color_code.invalid') }
  validates :design_file_id, presence: true
  validates :layer_id, presence: true
end
