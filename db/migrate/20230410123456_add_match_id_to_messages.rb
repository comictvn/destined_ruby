class AddMatchIdToMessages < ActiveRecord::Migration[6.0]
  def change
    add_reference :messages, :match, foreign_key: true
  end
end
