class RenameChanelToChannel < ActiveRecord::Migration[6.0]
  def change
    rename_table :chanels, :channels
  end
end