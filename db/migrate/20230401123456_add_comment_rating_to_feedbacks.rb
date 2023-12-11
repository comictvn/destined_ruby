class AddCommentRatingToFeedbacks < ActiveRecord::Migration[7.0]
  def change
    add_column :feedbacks, :comment, :text
    add_column :feedbacks, :rating, :integer
  end
end
