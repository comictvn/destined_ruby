class AddFeedbackToMatchFeedbacksTable < ActiveRecord::Migration[7.0]
  def change
    add_column :match_feedbacks, :feedback, :text
  end
end
