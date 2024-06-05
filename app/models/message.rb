class Message < ApplicationRecord
  belongs_to :sender,
             class_name: 'User'
  belongs_to :chanel

  validates_presence_of :content, message: I18n.t('activerecord.errors.messages.blank')
  validates_presence_of :sender_id, message: I18n.t('activerecord.errors.messages.blank')
  validates_presence_of :chanel_id, message: I18n.t('activerecord.errors.messages.blank')
  has_many_attached :images, dependent: :destroy

  validates :content, length: { in: 0..65_535 }, if: :content?
  validates :images, content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif', 'image/svg+xml'],
                     size: { less_than_or_equal_to: 100.megabytes }
end
