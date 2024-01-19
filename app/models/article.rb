
class Article < ApplicationRecord
  validates_presence_of :title, :content, message: ->(object, data) do
    I18n.t('activerecord.errors.messages.blank')
  end

  # ... rest of the model code ...
end
