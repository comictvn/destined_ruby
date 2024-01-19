class Article < ApplicationRecord
  # Specify the table name if it's not the pluralized form of the model name
  self.table_name = 'articles'

  # Define relationships with other models
  belongs_to :user
  has_many :media, dependent: :destroy
  has_many :article_tags, dependent: :destroy

  # Add validations for model attributes
  validates :title, presence: true, length: { maximum: 255 }, message: ->(object, data) do
    I18n.t('activerecord.errors.messages.blank')
  end
  validates :content, presence: true, message: ->(object, data) do
    I18n.t('activerecord.errors.messages.blank')
  end

  # The new code introduces a validation for status only on update
  # which conflicts with the existing validation for status.
  # To resolve this, we combine the conditions for the status validation.
  validates :status, presence: true, inclusion: { in: %w[draft published archived] }
  validates :status, inclusion: { in: ['published'] }, on: :update

  validates :user_id, presence: true

  # ... rest of the model code ...
end
