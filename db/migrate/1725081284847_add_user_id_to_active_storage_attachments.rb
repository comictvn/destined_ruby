class AddUserIdToActiveStorageAttachments < ActiveRecord::Migration[6.0]
  def change
    add_reference :active_storage_attachments, :user, index: true
  end
end