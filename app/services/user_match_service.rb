class UserMatchService < BaseService
  def initialize(id, preferences)
    @id = id
    @preferences = preferences
  end
  def find_potential_matches
    user = User.find(@id)
    potential_matches = User.where(@preferences).where.not(id: @id)
    if potential_matches.empty?
      { message: 'No more potential matches' }
    else
      total_matches = potential_matches.count
      potential_matches = potential_matches.paginate(page: 1, per_page: 10)
      total_pages = potential_matches.total_pages
      { matches: potential_matches, total_matches: total_matches, total_pages: total_pages }
    end
  end
end
