# typed: strict
class Library < ApplicationRecord
  belongs_to :user
  has_many :styles
  has_many :components

  validates :description, presence: true
  validates :user_id, presence: true
end

