# /app/services/user_preference_service.rb
class UserPreferenceService
  include ActiveModel::Validations

  validate :validate_preferences

  attr_accessor :user_id, :age_preference, :gender_preference, :location_preference, :interests_preference, :preference_data

  def initialize(user_id, preference_data = nil, age_preference = nil, gender_preference = nil, location_preference = nil, interests_preference = nil)
    @user_id = user_id
    @preference_data = preference_data
    @age_preference = age_preference
    @gender_preference = gender_preference
    @location_preference = location_preference
    @interests_preference = interests_preference
  end

  def update_preferences
    return unless valid?

    updated_preferences = nil
    ActiveRecord::Base.transaction do
      if @preference_data
        user_preference = UserPreference.find_or_initialize_by(user_id: @user_id)
        user_preference.preference_data = @preference_data
        user_preference.save!
      else
        user = User.find(@user_id)
        user.update!(
          age: @age_preference,
          gender: @gender_preference,
          location: @location_preference
        )
        UserInterest.where(user_id: @user_id).delete_all
        @interests_preference.each do |interest_id|
          UserInterest.create!(user_id: @user_id, interest_id: interest_id)
        end
        MatchingAlgorithm.update_user_preferences(user) if defined?(MatchingAlgorithm)
      end

      # Recalculate suggested matches
      updated_preferences = MatchmakingService.new(@user_id).recalculate_matches
    end

    updated_preferences
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Validation failed: #{e.message}"
    e.record.errors.full_messages.to_sentence
  rescue => e
    Rails.logger.error "Failed to update preferences: #{e.message}"
    "Failed to update preferences"
  end

  # New method to handle the updating of user preferences
  def update_user_preferences(user_id, preference_data)
    user = User.find_by(id: user_id)
    raise NotFoundException.new("User not found") unless user

    validate_user_preference_data(preference_data) # Assuming this is a method for validating preference_data

    suggested_matches = nil
    ActiveRecord::Base.transaction do
      user_preference = user.user_preference || user.build_user_preference
      user_preference.update!(preference_data: preference_data)

      # Recalculate suggested matches
      suggested_matches = MatchmakingService.new(user_id).refresh_user_matches
    end

    { success: true, message: "User preferences updated successfully." }
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Validation failed: #{e.message}"
    { success: false, message: e.record.errors.full_messages.to_sentence }
  rescue NotFoundException => e
    Rails.logger.error e.message
    { success: false, message: e.message }
  rescue => e
    Rails.logger.error "Failed to update user preferences: #{e.message}"
    { success: false, message: "Failed to update user preferences due to an unexpected error." }
  end

  private

  def validate_preferences
    if @preference_data
      errors.add(:preference_data, "must be a hash") unless preference_data.is_a?(Hash)
    else
      errors.add(:age_preference, "must be an integer") unless age_preference.is_a?(Integer)
      errors.add(:gender_preference, "is not included in the list") unless User.genders.keys.include?(gender_preference)
      errors.add(:location_preference, "must be a string") unless location_preference.is_a?(String)
      errors.add(:interests_preference, "must be an array of integers") unless interests_preference.is_a?(Array) && interests_preference.all? { |i| i.is_a?(Integer) }
    end
  end

  def validate_user_preference_data(preference_data)
    # Add validation logic for preference_data here
    # This is a placeholder for the actual implementation
  end
end

# Assuming MatchmakingService exists and has a method `refresh_user_matches`
class MatchmakingService
  def initialize(user_id)
    @user_id = user_id
  end

  def refresh_user_matches
    # Logic to refresh user matches based on updated preferences
    # This is a placeholder for the actual implementation
  end
end

# Assuming NotFoundException exists in /lib/exceptions.rb
class NotFoundException < StandardError; end
