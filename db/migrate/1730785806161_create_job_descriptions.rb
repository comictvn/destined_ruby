class CreateJobDescriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :job_descriptions do |t|
      t.text :details
      t.string :location_type
      t.string :city
      t.string :area
      t.string :pincode
      t.string :street_address
      t.string :status
      t.references :user, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end

  def down
    drop_table :job_descriptions
  end
end