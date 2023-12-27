# FILE PATH: /app/services/user_profile_service.rb
class UserProfileService
  include ActiveModel::Validations

  attr_accessor :user_id, :age, :gender, :location, :interests, :preferences, :personality_answers

  validate :validate_user_profile

  def initialize(user_id, age, gender, location, interests, preferences, personality_answers)
    @user_id = user_id
    @age = age
    @gender = gender
    @location = location
    @interests = interests
    @preferences = preferences
    @personality_answers = personality_answers
  end

  def update_user_profile
    user = User.find_by(id: user_id)
    return { error: 'User not found' } if user.nil?

    user_preference = Preference.find_or_initialize_by(user_id: user_id)
    ActiveRecord::Base.transaction do
      user.update!(age: age, gender: gender, location: location, updated_at: Time.current)
      user_preference.update!(preference_data: { interests: interests, preferences: preferences }.to_json, updated_at: Time.current)

      personality_answers.each do |answer|
        user_answer = UserAnswer.find_or_initialize_by(user_id: user_id, question_id: answer[:question_id])
        user_answer.update!(answer: answer[:answer], updated_at: Time.current)
      end
    end

    { success: true, user: user, preferences: user_preference }
  rescue ActiveRecord::RecordInvalid => e
    { error: e.message }
  rescue => e
    { error: e.message }
  end

  private

  def validate_user_profile
    errors.add(:base, 'Invalid age') unless age.is_a?(Integer) && age > 0
    errors.add(:base, 'Invalid gender') unless User.genders.keys.include?(gender)
    errors.add(:base, 'Invalid location') unless location.is_a?(String) && location.length > 0
    errors.add(:base, 'Invalid interests') unless interests.is_a?(Array) && interests.all? { |i| i.is_a?(String) }
    errors.add(:base, 'Invalid preferences') unless preferences.is_a?(Hash)
    errors.add(:base, 'Invalid personality_answers') unless personality_answers.is_a?(Array) && personality_answers.all? { |a| a[:question_id].is_a?(Integer) && a[:answer].is_a?(String) }
  end
end
