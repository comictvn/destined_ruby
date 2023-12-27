class PreferencesValidator < ActiveModel::Validator
  REQUIRED_FIELDS = %i[preference_data].freeze
  DATA_FIELDS = %i[likes dislikes interests].freeze
  UPDATED_PREFERENCES_FIELDS = %i[notifications email_updates].freeze # Added new fields for updated_preferences

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

    # Check for the presence of new required fields in updated_preferences
    UPDATED_PREFERENCES_FIELDS.each do |field|
      unless updated_preferences.key?(field)
        record.errors.add(:updated_preferences, "#{field} is required")
      end
    end

    updated_preferences.each do |key, value|
      unless (DATA_FIELDS + UPDATED_PREFERENCES_FIELDS).include?(key)
        record.errors.add(:updated_preferences, "contains unknown field: #{key}")
      end

      # Validate the data type for each field in updated_preferences
      case key
      when *DATA_FIELDS
        unless value.is_a?(Array)
          record.errors.add(:updated_preferences, "#{key} must be an array")
        end
      when *UPDATED_PREFERENCES_FIELDS
        unless [true, false].include?(value)
          record.errors.add(:updated_preferences, "#{key} must be a boolean")
        end
      end
    end
  end
end
