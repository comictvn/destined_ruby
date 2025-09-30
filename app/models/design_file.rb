# typed: strict
class DesignFile < ApplicationRecord
  has_many :text_layers, foreign_key: :design_file_id
end