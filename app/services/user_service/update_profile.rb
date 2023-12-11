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
    @interests = interests
    @preference_data = preference_data
  end

  def update_profile
    user = User.find_by(id: @user_id)
    return { error: 'User not found' } unless user

    ActiveRecord::Base.transaction do
      user.update!(age: @age, gender: @gender, location: @location)
      user.user_interests.destroy_all
      @interests.each do |interest_id|
        interest = Interest.find_or_create_by!(id: interest_id)
        UserInterest.create!(user_id: @user_id, interest_id: interest.id)
      end
      update_user_preferences(user) if @preference_data
    end

    { success: 'Profile and preferences updated successfully' }
  rescue ActiveRecord::RecordInvalid => e
    { error: e.message }
  end

  private

  def update_user_preferences(user)
    user_preference = user.user_preference || user.build_user_preference
    user_preference.update!(preference_data: @preference_data)
  end

  def validate_input_data
    errors.add(:age, 'must be a number') unless @age.is_a?(Integer)
    errors.add(:gender, 'must be a valid gender') unless ['male', 'female', 'other'].include?(@gender.downcase)
    errors.add(:location, 'must be a string') unless @location.is_a?(String)
    errors.add(:interests, 'must be an array of numbers') unless @interests.is_a?(Array) && @interests.all? { |i| i.is_a?(Integer) }
  end

  def validate_preference_data
    return if @preference_data.nil?
    errors.add(:preference_data, 'must be a hash') unless @preference_data.is_a?(Hash)
    # Add more specific validations for preference_data structure and content here
  end
end
# rubocop:enable Style/ClassAndModuleChildren
