class CreateDesignFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :design_files do |t|
      t.string :name
      t.datetime :last_modified

      t.timestamps
    end
  end
end