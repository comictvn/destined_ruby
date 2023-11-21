class UserMatchService < BaseService
  def initialize(id, preferences)
    @id = id
    @preferences = preferences
  end
  def find_potential_matches
    user = User.find_by(id: @id)
    raise ActiveRecord::RecordNotFound, "User not found" unless user
    matches = User.where(preferences: @preferences).where.not(id: @id).paginate(page: params[:page], per_page: 10)
    total_pages = matches.total_pages
    total_matches = matches.total_entries
    if matches.empty?
      { message: "No potential matches found" }
    else
      { matches: matches, total_pages: total_pages, total_matches: total_matches }
    end
  end
end
