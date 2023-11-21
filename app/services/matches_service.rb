class MatchesService
  def initialize(id, match_id, status)
    @id = id
    @match_id = match_id
    @status = status
  end
  def update_match_status
    match = Match.find_by(id: @match_id, user_id: @id)
    return { status: 'error', message: 'Match not found' } unless match
    if @status == 'like'
      if match.status == 'like'
        match.update(status: 'match')
        MatchMailer.match_notification(match).deliver_now
        { status: 'success', message: 'Matched!' }
      else
        match.update(status: 'like')
        { status: 'success', message: 'Liked!' }
      end
    elsif @status == 'dislike'
      match.update(status: 'dislike')
      { status: 'success', message: 'Disliked!' }
    else
      { status: 'error', message: 'Invalid status' }
    end
  end
end
