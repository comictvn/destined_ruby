class UpdateLibraries < ActiveRecord::Migration[6.0]
  def change
    add_column :libraries, :published_at, :datetime
  end
end
