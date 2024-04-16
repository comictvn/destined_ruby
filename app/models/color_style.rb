
# typed: strict
class ColorStyle < ApplicationRecord
  belongs_to :design_file
  # belongs_to :layer is removed as it is not mentioned in the new requirements
  validates :name, presence: { message: I18n.t('activerecord.errors.models.color_style.attributes.name.required') }, format: { with: /\A[a-zA-Z0-9\s]+\z/, message: I18n.t('activerecord.errors.models.color_style.attributes.name.invalid_format') }
  validates :color_code, presence: { message: I18n.t('activerecord.errors.models.color_style.attributes.color_code.required') }, format: { with: /\A#(?:[0-9a-fA-F]{3}){1,2}\z/, message: I18n.t('activerecord.errors.models.color_style.attributes.color_code.invalid_format') }
  validates :design_file_id, presence: { message: I18n.t('activerecord.errors.models.color_style.attributes.design_file_id.required') }
end
