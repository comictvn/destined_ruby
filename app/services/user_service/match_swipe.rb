# typed: true
class UserService::MatchSwipe < BaseService
  def initialize(*_args); end
  def swipe(id, matched_user_id, swipe_direction)
    if swipe_direction == 'right'
      match = Match.where(user_id: id, matched_user_id: matched_user_id).first
      if match
        match.update(matched: true)
        NotifyMatchJob.perform_later(id, matched_user_id)
        return 'Matched'
      end
    end
    'Not Matched'
  end
  def logger
    @logger ||= Rails.logger
  end
end
