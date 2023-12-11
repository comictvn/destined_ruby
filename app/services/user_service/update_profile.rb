# PATH: /app/services/user_service/update_profile.rb
# rubocop:disable Style/ClassAndModuleChildren
class UserService::UpdateProfile
  include ActiveModel::Validations

  validate :validate_input_data, :validate_preference_data

  def initialize(user_id, age, gender, location, interests, preference_data = nil)
    @user_id = user_id
    @age = age
    @gender = gender
    @location = location
    @interests = interests.map(&:downcase) # Ensure interests are stored consistently
    @preference_data = preference_data
  end

  def update_profile
    user = User.find_by(id: @user_id)
    return { error: 'User not found' } unless user

    if valid?
      ActiveRecord::Base.transaction do
        user.update!(age: @age, gender: @gender, location: @location)
        update_user_interests(user)
        update_user_preferences(user) if @preference_data
      end

      { success: 'Profile and preferences updated successfully' }
    else
      { error: errors.full_messages.join(', ') }
    end
  rescue ActiveRecord::RecordInvalid => e
    { error: e.message }
  rescue StandardError => e
    { error: e.message }
  end

  private

  def update_user_interests(user)
    existing_interests = user.interests.pluck(:name).map(&:downcase)
    new_interests = @interests - existing_interests
    removed_interests = existing_interests - @interests

    # Remove interests that are no longer associated with the user
    removed_interests.each do |interest_name|
      interest = Interest.find_by(name: interest_name)
      user.user_interests.find_by(interest_id: interest.id).destroy if interest
    end

    # Add new interests to the user
    new_interests.each do |interest_name|
      interest = Interest.find_or_create_by!(name: interest_name)
      user.user_interests.create!(interest_id: interest.id) unless user.interests.exists?(interest.id)
    end
  end

  def update_user_preferences(user)
    user_preference = user.user_preference || user.build_user_preference
    user_preference.update!(preference_data: @preference_data)
  end

  def validate_input_data
    errors.add(:age, 'must be a number') unless @age.is_a?(Integer)
    errors.add(:gender, 'must be a valid gender') unless ['male', 'female', 'other'].include?(@gender.downcase)
    errors.add(:location, 'must be a string') unless @location.is_a?(String)
    errors.add(:interests, 'must be an array of strings') unless @interests.is_a?(Array) && @interests.all? { |i| i.is_a?(String) }
  end

  def validate_preference_data
    return if @preference_data.nil?
    errors.add(:preference_data, 'must be a hash') unless @preference_data.is_a?(Hash)
    # Add more specific validations for preference_data structure and content here
  end
end
# rubocop:enable Style/ClassAndModuleChildren
