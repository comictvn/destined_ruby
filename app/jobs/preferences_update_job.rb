# /app/jobs/preferences_update_job.rb

class PreferencesUpdateJob < ApplicationJob
  queue_as :default

  def perform(user_id, updated_preferences)
    user = User.find_by(id: user_id)
    return unless user

    preferences = user.preferences
    return unless preferences

    # Update the user's preferences with the "updated_preferences" provided
    preferences.assign_attributes(updated_preferences)

    # Validate the updated preferences for correct format and completeness
    if preferences.valid?
      preferences.touch(:updated_at) # Update the "updated_at" timestamp
      preferences.save

      # Call the MatchingAlgorithmService with the updated preferences
      MatchingAlgorithmService.new(user).execute

      # Response with status and updated preferences data
      { status: 'success', updated_preferences: preferences }
    else
      # If validation fails, return an error status and the error messages
      { status: 'error', errors: preferences.errors.full_messages }
    end
  end
end
