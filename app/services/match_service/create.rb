# /app/services/match_service/create.rb
class MatchService < BaseService
  def create_match(user_id, matcher1_id, matcher2_id)
    ActiveRecord::Base.transaction do
      match = Match.find_or_initialize_by(matcher1_id: matcher1_id, matcher2_id: matcher2_id)
      
      if match.new_record?
        match.user_id = user_id
        match.save!
        # Send notification to both users
        MatchNotificationJob.perform_later(user_id, matcher1_id)
        MatchNotificationJob.perform_later(user_id, matcher2_id)
        { success: true, message: 'Match created successfully' }
      else
        { success: false, message: 'Match already exists' }
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    { success: false, error: e.message }
  rescue StandardError => e
    { success: false, error: e.message }
  end
end
