# /app/services/preferences_service.rb

class PreferencesService
  # Add any necessary requires or includes here
  include ActiveJob::Enqueuing

  # Existing code (if any) goes here

  # New method to update user preferences
  def update_user_preferences(user_id, updated_preferences)
    user_preferences = Preference.find_by(user_id: user_id)
    return { status: :not_found, message: 'Preferences not found' } unless user_preferences

    validation_result = PreferencesValidator.new(updated_preferences).validate
    return { status: :invalid, message: 'Invalid preferences', errors: validation_result.errors } unless validation_result.valid?

    user_preferences.update(preference_data: updated_preferences, updated_at: Time.current)

    # Enqueue the job to update the matching algorithm
    PreferencesUpdateJob.perform_later(user_id)

    { status: :ok, updated_preferences: user_preferences.preference_data }
  end

  # Rest of the class code goes here
end
