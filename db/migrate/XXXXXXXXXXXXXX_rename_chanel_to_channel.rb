class RenameChanelToChannel < ActiveRecord::Migration[6.0]
  def change
    rename_table :chanels, :channels
    rename_table :user_chanels, :user_channels
  end
end