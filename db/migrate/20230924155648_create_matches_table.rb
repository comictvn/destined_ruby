class CreateMatchesTable < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.float :compatibility_score
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
