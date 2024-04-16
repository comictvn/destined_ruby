
# typed: strict
class ColorStyle < ApplicationRecord
  belongs_to :design_file
  belongs_to :layer

  validates :name, presence: true
  validate :group_naming_convention
  validates :color_code, presence: true, format: { with: /\A#(?:[0-9a-fA-F]{3}){1,2}\z/ }
  validates :design_file_id, presence: { message: I18n.t('activerecord.errors.models.color_style.attributes.design_file_id.blank') }

  private

  def group_naming_convention
    errors.add(:name, I18n.t('activerecord.errors.models.color_style.attributes.name.invalid_group_naming')) unless name.include?('/')
  end
end
