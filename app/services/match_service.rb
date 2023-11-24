class MatchService
  def initialize(id, match_user_id)
    @id = id
    @match_user_id = match_user_id
  end
  def check_match_status
    match = Match.find_by(user_id: @id, match_id: @match_user_id)
    return { status: 'no match', match_user_id: @match_user_id } unless match&.status == 'like'
    reciprocal_match = Match.find_by(user_id: @match_user_id, match_id: @id)
    if reciprocal_match&.status == 'like'
      match.update!(status: 'match')
      reciprocal_match.update!(status: 'match')
      UserMailer.match_notification(User.find(@id), User.find(@match_user_id)).deliver_now
    end
    { status: match.status, match_user_id: @match_user_id }
  end
end
