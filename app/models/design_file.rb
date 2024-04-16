
# typed: strict
class DesignFile < ApplicationRecord
  has_many :layers, dependent: :destroy
  has_many :color_styles, dependent: :destroy

  validates :access_level, presence: { message: I18n.t('validation.design_file.access_level_required') }
end
