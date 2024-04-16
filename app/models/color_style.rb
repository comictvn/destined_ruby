
# typed: strict
class ColorStyle < ApplicationRecord
  belongs_to :design_file
  belongs_to :layer
  validates :name, presence: true, format: { with: /\A[a-zA-Z0-9\s]+\z/, message: I18n.t('activerecord.errors.models.color_style.attributes.name.invalid_format') }
  validates :color_code, presence: true, format: { with: /\A#(?:[0-9a-fA-F]{3}){1,2}\z/, message: I18n.t('activerecord.errors.models.color_style.attributes.color_code.invalid_format') }
  validates :design_file, presence: { message: I18n.t('activerecord.errors.messages.required') }
  validates :layer, presence: { message: I18n.t('activerecord.errors.messages.required') }
end
