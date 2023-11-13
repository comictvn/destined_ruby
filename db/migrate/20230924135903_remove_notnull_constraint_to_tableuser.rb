class RemoveNotnullConstraintToTableuser < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :dob, true
  end
end
