
# typed: strict
class ColorStyle < ApplicationRecord
  belongs_to :design_file
  belongs_to :layer

  validates :name, presence: { message: I18n.t('activerecord.errors.messages.blank') }, format: { with: /\A[a-zA-Z0-9_]+\z/, message: I18n.t('activerecord.errors.messages.invalid') }
  validates :color_code, presence: { message: I18n.t('activerecord.errors.messages.blank') }, format: { with: /\A#(?:[0-9a-fA-F]{3}){1,2}\z/i, message: I18n.t('activerecord.errors.messages.invalid') }
- validates :design_file_id, presence: true
+ validates :design_file_id, presence: { message: I18n.t('activerecord.errors.messages.blank') }
  validates :layer_id, presence: true
end
