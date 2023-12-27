# /app/services/match_service.rb
class MatchService
  include Pundit::Authorization

  attr_accessor :user_id, :user, :preferences, :user_answers, :potential_matches, :interests

  def initialize(user_id)
    @user_id = user_id
    @user = User.find(user_id)
    refresh_preferences # Call the new method to refresh preferences
    @user_answers = @user.user_answers.includes(:question)
    @potential_matches = []
  end

  def generate_potential_matches
    refresh_preferences # Ensure preferences are up-to-date before generating matches
    fetch_user_answers
    find_compatible_users_within_distance
    calculate_compatibility_scores
    sort_and_select_top_matches
  end

  def update_preferences(updated_preferences)
    @preferences.assign_attributes(updated_preferences)
    if @preferences.valid?
      @preferences.save
      refresh_preferences
      { status: 'success', data: @preferences }
    else
      { status: 'error', errors: @preferences.errors.full_messages }
    end
  end

  private

  # New method to refresh user preferences from the database
  def refresh_preferences
    @preferences = @user.preferences.reload
    @interests = @preferences.interests
  end

  def fetch_user_answers
    # User answers are already fetched in the initializer
  end

  def find_compatible_users_within_distance
    @potential_matches = MatchingAlgorithm.find_compatible_users_within_distance(@user, @preferences, @user_answers, @interests)
  end

  def calculate_compatibility_scores
    @potential_matches.each do |match|
      match[:score] = MatchingAlgorithm.calculate_compatibility(@user, match[:user], @preferences, match[:user_answers])
    end
  end

  def sort_and_select_top_matches
    @potential_matches.sort_by! { |match| -match[:score] }
    @potential_matches = @potential_matches.first(10) # Assuming we want the top 10 matches
  end
end
