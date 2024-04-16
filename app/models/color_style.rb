
# typed: strict
class ColorStyle < ApplicationRecord
  belongs_to :design_file
  belongs_to :layer
  validates :name, presence: { message: I18n.t('activerecord.errors.messages.blank') }
  validates :color_code, presence: { message: I18n.t('activerecord.errors.messages.blank') }, format: { with: /\A#(?:[0-9a-fA-F]{3}){1,2}\z/i, message: I18n.t('activerecord.errors.messages.invalid') }
  validates :design_file, presence: { message: I18n.t('activerecord.errors.messages.required') }
  validates :layer, presence: { message: I18n.t('activerecord.errors.messages.required') }
end
