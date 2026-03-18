class CreateSocialAuths < ActiveRecord::Migration[7.0]
  def change
    create_table :social_auths do |t|
      t.string :provider, null: false
      t.string :provider_user_id, null: false
      t.string :access_token, null: false
      t.string :access_token_secret

      t.timestamps
    end
  end
end