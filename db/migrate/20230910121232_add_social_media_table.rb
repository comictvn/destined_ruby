class AddSocialMediaTable < ActiveRecord::Migration[6.0]
  def change
    create_table :social_media do |t|
      t.string :platform
      t.string :email
      t.string :title
      t.text :content
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
