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

  def record_mutual_interest(user_id, matcher1_id, matcher2_id)
    ActiveRecord::Base.transaction do
      match_exists = Match.exists?(
        Match.arel_table[:matcher1_id].eq(matcher1_id).and(Match.arel_table[:matcher2_id].eq(matcher2_id))
      ) || Match.exists?(
        Match.arel_table[:matcher1_id].eq(matcher2_id).and(Match.arel_table[:matcher2_id].eq(matcher1_id))
      )

      unless match_exists
        match = Match.new(user_id: user_id, matcher1_id: matcher1_id, matcher2_id: matcher2_id)
        match.save!
        # Send notification to both users
        MatchNotificationJob.perform_later(matcher1_id, 'You have a new match!')
        MatchNotificationJob.perform_later(matcher2_id, 'You have a new match!')
        { success: true, match: match, message: 'Mutual interest recorded and match created successfully' }
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
