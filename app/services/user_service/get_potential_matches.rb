# rubocop:disable Style/ClassAndModuleChildren
class UserService::GetPotentialMatches
  attr_accessor :id, :preferences
  def initialize(id, preferences)
    @id = id
    @preferences = preferences
  end
  def call
    validate_input
    user = User.find_by(id: @id)
    raise StandardError, 'User not found' unless user
    potential_matches = User.where(preferences: @preferences)
    potential_matches = potential_matches.where.not(id: user.id)
    potential_matches = potential_matches.where.not(id: Match.where(user_id: user.id).pluck(:match_id))
    total_matches = potential_matches.count
    total_pages = (total_matches / 10.0).ceil
    {
      potential_matches: potential_matches.paginate(page: 1, per_page: 10),
      total_matches: total_matches,
      total_pages: total_pages
    }
  end
  private
  def validate_input
    errors = []
    errors << 'User ID is required' if @id.blank?
    errors << 'User ID is not a number' unless @id.is_a?(Numeric)
    errors << 'Preferences are required' if @preferences.blank?
    raise StandardError, errors.join(', ') unless errors.empty?
  end
end
# rubocop:enable Style/ClassAndModuleChildren
