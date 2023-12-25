class Swipe < ApplicationRecord
  belongs_to :user

  # validations
  validates :direction, presence: true
  validates :user_id, presence: true

  enum direction: { left: 0, right: 1 }, _suffix: true
end
