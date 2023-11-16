# PATH: /app/services/match_service/update.rb
# rubocop:disable Style/ClassAndModuleChildren
class MatchService::Update
  attr_accessor :id, :matched_user_id, :status
  def initialize(id, matched_user_id, status)
    @id = id
    @matched_user_id = matched_user_id
    @status = status
  end
  def call
    validate_input
    match = Match.find_by(id: @id, matched_user_id: @matched_user_id)
    raise StandardError, 'Match not found' unless match
    match.update!(status: @status)
    if @status == 'like'
      matched_record = Match.find_by(id: @matched_user_id, matched_user_id: @id, status: 'like')
      if matched_record
        match.update!(status: 'match')
        matched_record.update!(status: 'match')
        NotificationService.new(@id, 'You have a new match').call
        NotificationService.new(@matched_user_id, 'You have a new match').call
      end
    end
    { message: 'Match updated successfully', match: match }
  rescue StandardError => e
    raise StandardError, 'An unexpected error occurred', message: e.message
  end
  private
  def validate_input
    errors = []
    errors << 'ID is required' if @id.blank?
    errors << 'Matched User ID is required' if @matched_user_id.blank?
    errors << 'Status is required' if @status.blank?
    raise StandardError, errors.join(', ') unless errors.empty?
  end
end
# rubocop:enable Style/ClassAndModuleChildren
