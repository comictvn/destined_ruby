class MatchService::Update < BaseService
  def initialize(id, result)
    @id = id
    @result = result
  end
  def call
    raise ArgumentError, "Wrong format" unless @id.is_a?(Integer)
    raise ArgumentError, "Invalid result." unless Match.results.keys.include?(@result)
    match = Match.find_by(id: @id)
    raise ActiveRecord::RecordNotFound, "This match is not found" unless match
    match.update!(result: @result)
    match
  rescue ActiveRecord::RecordInvalid => e
    raise e
  end
end
