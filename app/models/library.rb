# typed: strict
class Library < ApplicationRecord
  belongs_to :user
  has_many :styles
  has_many :components

  validates :description, presence: true
  validates :user_id, presence: true

  # Publishes components and styles by creating a new library and associated records
  def self.publish_components_and_styles(components, styles, description, designer_id)
    transaction do
      library = create!(description: description, user_id: designer_id)

      components.each do |component|
        library.components.create!(name: component[:name])
      end

      styles.each do |style|
        library.styles.create!(name: style[:name])
      end

      library.update!(published_at: Time.current)
    end
  rescue ActiveRecord::RecordInvalid => e
    raise Exceptions::PublishingError, e.record.errors.full_messages.to_sentence
  end
end