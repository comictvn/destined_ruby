
# typed: strict
include I18n
class ColorStyle < ApplicationRecord
  belongs_to :design_file
  belongs_to :layer

  validates :name, presence: { message: I18n.t('activerecord.errors.messages.blank') }
  validates :color_code, presence: true, format: { with: /\A#[0-9A-F]{6}\z/i, message: I18n.t('activerecord.errors.models.color_style.attributes.color_code.invalid') }
  validates :design_file_id, :layer_id, presence: { message: I18n.t('activerecord.errors.messages.blank') }
end
