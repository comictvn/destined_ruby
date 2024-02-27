class ForceUpdateAppVersion < ApplicationRecord
  enum platform: %w[ios android], _suffix: true

  # Validation for platform inclusion from new code with updated error message
  validates :platform, inclusion: { in: platforms.keys, message: I18n.t('activerecord.errors.models.force_update_app_version.attributes.platform.invalid') }
  
  # Validation for force_update inclusion from new code with updated error message
  validates :force_update, inclusion: { in: [true, false], message: I18n.t('activerecord.errors.models.force_update_app_version.attributes.force_update.invalid') }
  
  # Merged the presence and uniqueness validations for version from both new and existing code with updated error message
  validates :version, presence: { message: I18n.t('activerecord.errors.models.force_update_app_version.attributes.version.blank') }, uniqueness: { scope: :platform, message: I18n.t('activerecord.errors.models.force_update_app_version.attributes.version.taken_scoped') }
  
  # Removed the length validation for version from new code as it conflicts with the existing range validation
  # Kept the existing range validation for version
  validates :version, length: { in: 0..255 }, if: :version?
  
  # Merged the presence validation from existing code with the length validation from new code for reason with updated error message
  validates :reason, presence: true, length: { maximum: 500, too_long: I18n.t('activerecord.errors.models.force_update_app_version.attributes.reason.too_long') }, if: :reason?
end
