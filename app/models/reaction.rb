class Reaction < ApplicationRecord
  belongs_to :reacter,
             class_name: 'User'
  belongs_to :reacted,
             class_name: 'User'

  # Resolving the conflict by combining the enum definitions
  # The new code uses a hash syntax while the current code uses an array.
  # The hash syntax is more extensible and allows for additional metadata if needed in the future.
  enum react_type: { likes: 0, dislikes: 1, follows: 2 }, _suffix: true
end
