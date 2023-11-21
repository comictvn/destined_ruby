class MatchService
  def get_potential_matches(id, preferences, page = 1, per_page = 10)
    user = User.find_by_id(id)
    return { error: 'User not found' } unless user
    user_preferences = user.preferences || preferences
    potential_matches = User.where(user_preferences)
                            .where.not(id: user.id)
                            .where.not(id: Match.where(user_id: user.id).pluck(:match_id))
    total_matches = potential_matches.count
    total_pages = (total_matches / per_page.to_f).ceil
    potential_matches = potential_matches.paginate(page: page, per_page: per_page)
    { potential_matches: potential_matches, total_matches: total_matches, total_pages: total_pages }
  end
end
