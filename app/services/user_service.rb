class UserService
  def initialize(user_id)
    @user_id = user_id
  end
  def find_potential_matches
    user = User.find_by_id(@user_id)
    raise ActiveRecord::RecordNotFound, "User not found" unless user
    potential_matches = User.where(preferences: user.preferences)
    return "No potential matches found" if potential_matches.empty?
    potential_matches
  end
end
