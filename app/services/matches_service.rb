class MatchesService
  def initialize(id, matched_user_id, status)
    @id = id
    @matched_user_id = matched_user_id
    @status = status
  end
  def update_status
    user = User.find_by(id: @id)
    return { error: 'User not found' } unless user
    matched_user = User.find_by(id: @matched_user_id)
    return { error: 'Matched user not found' } unless matched_user
    match = Match.find_by(id: @id)
    return { error: 'Match not found' } unless match
    match.update(status: @status)
    if match.status == 'match' && matched_user.matches.find_by(id: @id).status == 'match'
      UserMailer.send_match_notification(user, matched_user).deliver_now
      UserMailer.send_match_notification(matched_user, user).deliver_now
    end
    match
  end
end
