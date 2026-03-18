# typed: strict
class ActiveStorageAttachment < ApplicationRecord
  belongs_to :blob, class_name: 'ActiveStorageBlob', foreign_key: 'blob_id', optional: true
  belongs_to :user, foreign_key: 'user_id', optional: true
  has_one :active_storage_blob, foreign_key: 'active_storage_attachment_id'

  # Add validations and any other model logic here
end

