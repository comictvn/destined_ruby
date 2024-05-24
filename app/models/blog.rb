class Blog < ApplicationRecord
  belongs_to :user, foreign_key: 'user_id'

  # Validations
  validates :title, presence: true
  validates :content, presence: true
end
