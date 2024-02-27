class AddChanelIdToMessages < ActiveRecord::Migration[6.0]
  def up
    add_reference :messages, :chanel, foreign_key: true
  end

  def down
    remove_reference :messages, :chanel, foreign_key: true
  end
end
