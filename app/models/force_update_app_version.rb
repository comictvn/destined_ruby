class ForceUpdateAppVersion < ApplicationRecord
  enum platform: %w[ios android], _suffix: true

  validates :platform, inclusion: { in: platforms.keys, message: I18n.t('activerecord.errors.messages.invalid_platform') }
  validates :force_update, inclusion: { in: [true, false], message: I18n.t('activerecord.errors.messages.force_update_boolean') }
  validates :version, presence: { message: I18n.t('activerecord.errors.messages.version_blank') }
  validates :version, uniqueness: { scope: :platform, message: I18n.t('activerecord.errors.messages.taken_scoped') }
  validates :version, length: { in: 0..255 }, if: :version?
  validates :reason, length: { maximum: 500, message: I18n.t('activerecord.errors.messages.reason_too_long') }, if: :reason?
end
