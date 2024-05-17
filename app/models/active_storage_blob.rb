# typed: strict
class ActiveStorageBlob < ApplicationRecord
  has_many :attachments, class_name: 'ActiveStorageAttachment', foreign_key: 'blob_id', dependent: :destroy
  has_many :variant_records, class_name: 'ActiveStorageVariantRecord', foreign_key: 'blob_id', dependent: :destroy

  validates :key, presence: true
  validates :filename, presence: true
  validates :byte_size, presence: true

  # Additional fields and methods (if any) should be added below this line

end
