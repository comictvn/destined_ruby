class MatchService
  def self.create(team1, team2, date)
    match = Match.new(team1: team1, team2: team2, date: date)
    MatchValidator.new(match).validate
    match.save!
    return {id: match.id, team1: match.team1, team2: match.team2, date: match.date, result: match.result}
  end
end
