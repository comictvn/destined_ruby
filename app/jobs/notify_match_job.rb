class NotifyMatchJob < ApplicationJob
  queue_as :default
  def perform(match)
    MatchMailer.match_notification(match).deliver_now
  end
end
