class ForceUpdateAppVersion < ApplicationRecord
  enum platform: %w[ios android], _suffix: true

  validates :platform, inclusion: { in: platforms.keys }
  validates :force_update, inclusion: { in: [true, false] }
  validates :version, presence: true
  # Merged the uniqueness validation and custom message from new code with the existing scope validation
  validates :version, uniqueness: { scope: :platform, message: I18n.t('activerecord.errors.messages.taken_scoped') }
  # Merged the length validation from new code with the existing range validation
  validates :version, length: { maximum: 255 }, if: :version?
  # Merged the presence validation from existing code with the length validation from new code
  validates :reason, presence: true, length: { maximum: 255 }, if: :reason?
end
