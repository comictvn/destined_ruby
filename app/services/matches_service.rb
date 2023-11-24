class MatchesService
  def initialize(id, match_user_id, status)
    @id = id
    @match_user_id = match_user_id
    @status = status
  end
  def update_match_status
    user = User.find_by_id(@match_user_id)
    if user
      match = Match.find_by_id(@id)
      if match
        match.update(user_id: user.id, status: @status)
        return { status: 'success', match_user_id: @match_user_id }
      else
        return { status: 'error', message: 'Match not found' }
      end
    else
      return { status: 'error', message: 'User not found' }
    end
  end
end
