# /app/services/match_service.rb
class MatchService
  include Pundit::Authorization

  attr_accessor :user_id, :user, :preferences, :user_answers, :potential_matches, :interests

  def initialize(user_id)
    @user_id = user_id
    @user = User.find(user_id)
    @preferences = @user.preferences
    @user_answers = @user.user_answers.includes(:question)
    @potential_matches = []
  end

  def generate_potential_matches
    retrieve_preferences_and_interests
    fetch_user_answers
    find_compatible_users_within_distance
    calculate_compatibility_scores
    sort_and_select_top_matches
  end

  private

  def retrieve_preferences_and_interests
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
