class MatchService < BaseService
  def initialize(id)
    raise ArgumentError, "Wrong format" unless id.is_a?(Integer)
    @id = id
  end
  def get_match
    match = Match.find_by(id: @id)
    raise ActiveRecord::RecordNotFound, "This match is not found" unless match
    {
      "status": 200,
      "match": {
        "id": match.id,
        "team1": match.team1,
        "team2": match.team2,
        "date": match.date,
        "result": match.result
      }
    }
  end
end
