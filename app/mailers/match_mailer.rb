class MatchMailer < ApplicationMailer
  def match_notification(user_id, match_id)
    @user = User.find(user_id)
    @match = Match.find(match_id)
    @match_user = User.find(@match.user_id)
    @message = case @match.status
               when 'pending'
                 "You have a new match pending!"
               when 'accepted', 'match'
                 "Congratulations! Your match has been accepted!"
               when 'rejected', 'dislike'
                 "Sorry, your match has been rejected."
               else
                 "You have a new match status update."
               end
    mail(to: [@user.email, @match_user.email], subject: 'Match Notification')
  end
end
