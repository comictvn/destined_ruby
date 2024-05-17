# typed: strict
class ActiveStorageAttachment < ApplicationRecord
  belongs_to :blob, class_name: 'ActiveStorageBlob', foreign_key: 'blob_id'

  validates :name, presence: true
  validates :record_type, presence: true
  validates :record_id, presence: true

  # Additional model code...

end
