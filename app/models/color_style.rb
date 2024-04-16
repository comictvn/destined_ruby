
# typed: strict
class ColorStyle < ApplicationRecord
  belongs_to :design_file
  belongs_to :layer

  validates :name, presence: { message: I18n.t('activerecord.errors.models.color_style.attributes.name.blank') }
  validates :color_code, presence: { message: I18n.t('activerecord.errors.models.color_style.attributes.color_code.blank') },
                         format: { with: /\A#(?:[0-9a-fA-F]{3}){1,2}\z/, message: I18n.t('activerecord.errors.models.color_style.attributes.color_code.invalid_format') }
  validates :design_file_id, presence: { message: I18n.t('activerecord.errors.models.color_style.attributes.design_file_id.blank') }
  validates :layer_id, presence: { message: I18n.t('activerecord.errors.models.color_style.attributes.layer_id.blank') }

  # Removed the validation for layer_id as it is not mentioned in the requirements
end
