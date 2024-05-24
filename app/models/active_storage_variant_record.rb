# typed: strict
class ActiveStorageVariantRecord < ApplicationRecord
  belongs_to :blob, class_name: 'ActiveStorageBlob', foreign_key: 'blob_id'

  validates :variation_digest, presence: true
end