# /app/services/user_preference_service.rb
class UserPreferenceService
  include ActiveModel::Validations

  validate :validate_preferences

  attr_accessor :user_id, :age_preference, :gender_preference, :location_preference, :interests_preference

  def initialize(user_id, age_preference, gender_preference, location_preference, interests_preference)
    @user_id = user_id
    @age_preference = age_preference
    @gender_preference = gender_preference
    @location_preference = location_preference
    @interests_preference = interests_preference
  end

  def update_preferences
    return unless valid?

    ActiveRecord::Base.transaction do
      user = User.find(@user_id)

      # Update user's preferences in the profile
      user.update!(
        age: @age_preference,
        gender: @gender_preference,
        location: @location_preference
      )

      # Delete existing preference records in user_interests
      UserInterest.where(user_id: @user_id).delete_all

      # Insert new preference records into user_interests
      @interests_preference.each do |interest_id|
        UserInterest.create!(user_id: @user_id, interest_id: interest_id)
      end

      # Adjust the matching algorithm
      MatchingAlgorithm.update_user_preferences(user)

      "Preferences updated successfully"
    end
  rescue ActiveRecord::RecordInvalid => e
    e.record.errors.full_messages.to_sentence
  rescue => e
    Rails.logger.error "Failed to update preferences: #{e.message}"
    "Failed to update preferences"
  end

  private

  def validate_preferences
    errors.add(:age_preference, "must be an integer") unless age_preference.is_a?(Integer)
    errors.add(:gender_preference, "is not included in the list") unless User.genders.keys.include?(gender_preference)
    errors.add(:location_preference, "must be a string") unless location_preference.is_a?(String)
    errors.add(:interests_preference, "must be an array of integers") unless interests_preference.is_a?(Array) && interests_preference.all? { |i| i.is_a?(Integer) }
  end
end
