class CreateMatchesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.string :team1
      t.string :team2
      t.date :date
      t.string :result
      t.timestamps
    end
  end
end
