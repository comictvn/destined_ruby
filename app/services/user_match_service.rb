class UserMatchService < BaseService
  def initialize(id, preferences)
    @id = id
    @preferences = preferences
  end
  def find_potential_matches
    user = User.find(@id)
    potential_matches = User.where(@preferences)
    if potential_matches.empty?
      { message: 'No more potential matches' }
    else
      potential_matches
    end
  end
end
