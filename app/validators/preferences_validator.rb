class PreferencesValidator < ActiveModel::Validator
  REQUIRED_FIELDS = %i[preference_data].freeze
  DATA_FIELDS = %i[likes dislikes interests].freeze

  def validate(record)
    preference_data = record.preference_data
    unless preference_data.is_a?(Hash)
      record.errors.add(:preference_data, 'must be a hash')
      return
    end

    REQUIRED_FIELDS.each do |field|
      unless preference_data.key?(field)
        record.errors.add(field, 'is required')
      end
    end

    validate_data_fields(preference_data, record) if preference_data.is_a?(Hash)
    validate_updated_preferences(preference_data, record) if preference_data.key?(:updated_preferences)
  end

  private

  def validate_data_fields(preference_data, record)
    DATA_FIELDS.each do |field|
      unless preference_data[field].is_a?(Array)
        record.errors.add(field, 'must be an array')
      end
    end
  end

  def validate_updated_preferences(preference_data, record)
    updated_preferences = preference_data[:updated_preferences]
    return unless updated_preferences

    unless updated_preferences.is_a?(Hash)
      record.errors.add(:updated_preferences, 'must be a hash')
      return
    end

    updated_preferences.each do |key, value|
      unless DATA_FIELDS.include?(key)
        record.errors.add(:updated_preferences, "contains unknown field: #{key}")
      end

      unless value.is_a?(Array)
        record.errors.add(:updated_preferences, "#{key} must be an array")
      end
    end
  end
end
