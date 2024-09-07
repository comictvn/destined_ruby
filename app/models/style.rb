# typed: strict
class Style < ApplicationRecord
  belongs_to :library

  validates :name, presence: true
  validates :library_id, presence: true
end