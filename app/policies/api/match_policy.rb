class Api::MatchPolicy
  attr_reader :user, :match
  def initialize(user, match)
    @user = user
    @match = match
  end
  def authorize?
    user.id == match.matcher1_id || user.id == match.matcher2_id
  end
end
