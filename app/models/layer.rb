
# typed: strict
class Layer < ApplicationRecord
  belongs_to :design_file
  has_many :color_styles
  belongs_to :color_style, optional: true

  validates :name, presence: true
  validates :name, uniqueness: { scope: :design_file_id, message: I18n.t('validation.errors.layer_name_uniqueness') }
  validates :design_file_id, presence: true
end
