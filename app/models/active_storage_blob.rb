# typed: strict
class ActiveStorageBlob < ApplicationRecord
  belongs_to :active_storage_attachment, foreign_key: 'active_storage_attachment_id', optional: true
  has_many :active_storage_attachments, foreign_key: 'blob_id'
  has_many :active_storage_variant_records, foreign_key: 'blob_id'
  # Add validations and any other model logic here

  # Validations for the photo's metadata
  validates :filename, presence: true
  validates :content_type, presence: true, inclusion: { in: ['image/jpeg', 'image/png'], message: 'Invalid photo format' }
  validates :byte_size, presence: true, numericality: { less_than_or_equal_to: 5.megabytes, message: 'Photo exceeds maximum size limit' }
  validates :checksum, presence: true

  validate :validate_photo

  private

  def validate_photo
    errors.add(:photo, 'is invalid') unless photo.attached? && photo.content_type.in?(%w[image/jpeg image/png])
  end
end