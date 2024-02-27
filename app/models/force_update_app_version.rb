class ForceUpdateAppVersion < ApplicationRecord
  enum platform: %w[ios android], _suffix: true

  # Validation for platform inclusion remains unchanged
  validates :platform, inclusion: { in: platforms.keys, message: I18n.t('activerecord.errors.models.force_update_app_version.attributes.platform.invalid') }
  
  # Validation for force_update inclusion remains unchanged
  validates :force_update, inclusion: { in: [true, false], message: I18n.t('activerecord.errors.models.force_update_app_version.attributes.force_update.invalid') }
  
  # Merged the presence and uniqueness validations for version from both new and existing code
  validates :version, presence: { message: I18n.t('activerecord.errors.models.force_update_app_version.attributes.version.blank') }, uniqueness: { scope: :platform, message: I18n.t('activerecord.errors.messages.taken_scoped') }
  
  # Merged the length validation for version from new code with the existing range validation
  validates :version, length: { in: 0..255 }, if: :version?
  
  # Merged the presence validation from existing code with the length validation from new code for reason
  validates :reason, presence: true, length: { maximum: 500, too_long: I18n.t('activerecord.errors.models.force_update_app_version.attributes.reason.too_long') }, if: :reason?
end
