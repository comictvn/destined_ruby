
class ForceUpdateAppVersion < ApplicationRecord
  enum platform: %w[ios android], _suffix: true

  validates :platform, inclusion: { in: platforms.keys }
  validates :force_update, inclusion: { in: [true, false] }
  validates :version, presence: true, uniqueness: { scope: :platform }
  validates :version, length: { in: 0..255 }, if: :version?
  validates :reason, presence: true, length: { maximum: 500 }
end
