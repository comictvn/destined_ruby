class UserChanel < ApplicationRecord
  belongs_to :chanel, foreign_key: 'chanel_id'
  belongs_to :user, foreign_key: 'user_id'
end
