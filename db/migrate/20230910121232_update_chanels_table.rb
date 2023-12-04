class UpdateChanelsTable < ActiveRecord::Migration[6.0]
  def change
    change_table :chanels do |t|
      t.string :name
      t.text :description
    end
  end
end
