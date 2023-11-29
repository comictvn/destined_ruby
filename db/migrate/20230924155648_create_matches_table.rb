class CreateMatchesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.float :compatibility_score
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
