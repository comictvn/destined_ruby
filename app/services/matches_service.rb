class MatchesService < BaseService
  def initialize(id, match_id, status)
    @id = id
    @match_id = match_id
    @status = status
  end
  def update_status
    match = Match.find_by(id: @id, match_id: @match_id)
    if match
      match.update(status: @status)
      if @status == "like" && match.user.matches.find_by(match_id: @id)&.status == "like"
        NotificationsService.new(match.user_id, @id, "You both liked each other").create_notification
        NotificationsService.new(@id, match.user_id, "You both liked each other").create_notification
      end
      return "Success message, match status: #{@status}"
    else
      raise ActiveRecord::RecordNotFound, "Match not found"
    end
  end
end
