class ForceUpdateAppVersion < ApplicationRecord
  enum platform: %w[ios android], _suffix: true

  validates :version, presence: { message: I18n.t('activerecord.errors.messages.blank') }
  validates :version, length: { maximum: 255, message: I18n.t('activerecord.errors.messages.too_long', count: 255) }, if: :version?
  validates :reason, length: { maximum: 65_535, message: I18n.t('activerecord.errors.messages.too_long', count: 65_535) }, if: :reason?
end
