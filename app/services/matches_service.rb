class MatchesService
  def get_match(id)
    match = Match.find_by(id: id)
    raise StandardError.new("Match not found.") unless match
    match
  end
end
