class CreateMatchesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.references :user, foreign_key: true
      t.string :team1
      t.string :team2
      t.datetime :date
      t.string :result
      t.string :status
      t.timestamps
    end
  end
end
