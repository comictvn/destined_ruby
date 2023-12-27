# /app/services/preferences_service.rb

class PreferencesService
  # Add any necessary requires or includes here
  include ActiveJob::Enqueuing

  # Existing code (if any) goes here

  # New method to update user preferences
  def update_user_preferences(user_id, updated_preferences)
    user_preferences = Preference.find_by(user_id: user_id)
    return { status: :not_found, message: 'Preferences not found' } unless user_preferences

    # Merge the updated_preferences with the existing preferences
    merged_preferences = user_preferences.preference_data.merge(updated_preferences)

    # Validate the merged preferences
    validation_result = PreferencesValidator.new(merged_preferences).validate
    unless validation_result.valid?
      return { status: :invalid, message: 'Invalid preferences', errors: validation_result.errors }
    end

    # Update the preferences record with the new merged preferences
    begin
      user_preferences.update!(preference_data: merged_preferences, updated_at: Time.current)
    rescue => e
      return { status: :error, message: 'Failed to update preferences', errors: e.message }
    end

    # Enqueue the job to update the matching algorithm
    PreferencesUpdateJob.perform_later(user_id)

    { status: :ok, updated_preferences: user_preferences.preference_data }
  end

  # Rest of the class code goes here
end
