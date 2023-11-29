class UserPreferenceService < BaseService
  def initialize(user_id, preferences)
    @user_id = user_id
    @preferences = preferences
  end
  def update_preferences
    user = find_user
    validate_preferences
    user.update!(preferences: @preferences)
    recalculate_compatibility_scores(user)
    { preferences: user.preferences, message: 'Preferences updated successfully' }
  end
  private
  def find_user
    user = User.find_by(id: @user_id)
    raise ActiveRecord::RecordNotFound, 'User not found' unless user
    user
  end
  def validate_preferences
    validator = UserPreferenceValidator.new(@preferences)
    errors = validator.validate
    raise ActiveRecord::RecordInvalid, errors.full_messages.join(", ") unless errors.empty?
  end
  def recalculate_compatibility_scores(user)
    CompatibilityScoreService.new(user).recalculate
  end
end
