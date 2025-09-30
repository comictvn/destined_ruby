# typed: strict
class ActiveStorageBlob < ApplicationRecord
  belongs_to :active_storage_attachment, foreign_key: 'active_storage_attachment_id', optional: true
  has_many :active_storage_attachments, foreign_key: 'blob_id'
  has_many :active_storage_variant_records, foreign_key: 'blob_id'
  # Add validations and any other model logic here
end

