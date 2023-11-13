class Reaction < ApplicationRecord
  belongs_to :reacter,
             class_name: 'User'
  belongs_to :reacted,
             class_name: 'User'

  enum react_type: %w[likes dislikes follows], _suffix: true
end
