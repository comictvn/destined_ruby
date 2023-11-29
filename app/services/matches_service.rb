class MatchesService
  def initialize(user_id)
    @user_id = user_id
  end
  def suggest_matches
    matches = Match.where(user_id: @user_id).order(compatibility_score: :desc)
    suggested_matches = matches.map { |match| match.id }
    user = User.find(@user_id)
    user.update(suggested_matches: suggested_matches)
    user.suggested_matches
  end
end
