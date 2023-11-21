class MatchService
  def initialize
  end
  def find_potential_matches(id, preferences, page = 1, per_page = 10)
    user = User.find(id)
    potential_matches = User.where(preferences)
                            .where.not(id: user.matches.pluck(:match_id))
                            .paginate(page: page, per_page: per_page)
    total_matches = potential_matches.total_entries
    total_pages = potential_matches.total_pages
    {
      potential_matches: potential_matches,
      total_matches: total_matches,
      total_pages: total_pages
    }
  end
end
