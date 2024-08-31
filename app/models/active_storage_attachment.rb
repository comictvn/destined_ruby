# typed: strict
class ActiveStorageAttachment < ApplicationRecord
  belongs_to :blob, class_name: 'ActiveStorageBlob', foreign_key: 'blob_id', optional: true
  belongs_to :user, foreign_key: 'user_id', optional: true
  has_one :active_storage_blob, foreign_key: 'active_storage_attachment_id'

  # Validations
  validates :record_id, presence: true
  validates :blob_id, presence: true
  validate :profile_photo_attachment_name

  private

  def profile_photo_attachment_name
    errors.add(:name, 'must be set to profile_photo for User record type') if record_type == 'User' && name != 'profile_photo'
  end
  # Add validations and any other model logic here
end