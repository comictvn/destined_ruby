class ForceUpdateAppVersion < ApplicationRecord
  enum platform: %w[ios android], _suffix: true

  validates :force_update, inclusion: { in: [true, false] }
  validates :reason, length: { in: 0..65_535 }, if: :reason?
  validates :version, presence: true
  validates :version, length: { in: 0..255 }, if: :version?
end
