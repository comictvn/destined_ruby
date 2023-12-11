# PATH: /app/services/user_service/update_profile.rb
# rubocop:disable Style/ClassAndModuleChildren
class UserService::UpdateProfile
  include ActiveModel::Validations

  validate :validate_input_data

  def initialize(user_id, age, gender, location, interests)
    @user_id = user_id
    @age = age
    @gender = gender
    @location = location
    @interests = interests
  end

  def update_profile
    user = User.find_by(id: @user_id)
    return { error: 'User not found' } unless user

    ActiveRecord::Base.transaction do
      user.update!(age: @age, gender: @gender, location: @location)
      user.user_interests.destroy_all
      @interests.each do |interest_id|
        UserInterest.create!(user_id: @user_id, interest_id: interest_id)
      end
    end

    { success: 'Profile updated successfully' }
  rescue ActiveRecord::RecordInvalid => e
    { error: e.message }
  end

  private

  def validate_input_data
    errors.add(:age, 'must be a number') unless @age.is_a?(Integer)
    errors.add(:gender, 'must be a valid gender') unless ['male', 'female', 'other'].include?(@gender.downcase)
    errors.add(:location, 'must be a string') unless @location.is_a?(String)
    errors.add(:interests, 'must be an array of numbers') unless @interests.is_a?(Array) && @interests.all? { |i| i.is_a?(Integer) }
  end
end
# rubocop:enable Style/ClassAndModuleChildren
