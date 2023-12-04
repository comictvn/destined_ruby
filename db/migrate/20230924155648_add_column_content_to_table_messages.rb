class AddColumnContentToTableMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :content, :text, null: true
  end
end
