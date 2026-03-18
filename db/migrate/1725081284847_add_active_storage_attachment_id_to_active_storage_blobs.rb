class AddActiveStorageAttachmentIdToActiveStorageBlobs < ActiveRecord::Migration[6.0]
  def change
    add_reference :active_storage_blobs, :active_storage_attachment, index: true
  end
end