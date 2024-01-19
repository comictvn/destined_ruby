class AddOauthApplicationIdToOauthAccessTokens < ActiveRecord::Migration[6.1]
  def change
    unless column_exists?(:oauth_access_tokens, :oauth_application_id)
      add_reference :oauth_access_tokens, :oauth_application_id, foreign_key: { to_table: :oauth_applications }
    end
  end
end
