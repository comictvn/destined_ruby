module UserService
  class MatchGenerator < BaseService
    def initialize(user_id)
      @user_id = user_id
    end
    def call
      user = User.find(@user_id)
      return unless user
      preferences = user.preferences
      interests = user.interests
      matches = calculate_matches(preferences, interests)
      matches.each do |match|
        Match.create(user_id: @user_id, matched_user_id: match[:user_id], compatibility_score: match[:score])
      end
      Match.where(user_id: @user_id)
    rescue ActiveRecord::RecordNotFound
      logger.error("User with id #{@user_id} not found.")
    end
    private
    def calculate_matches(preferences, interests)
      # Implement your matching algorithm here
      # This is just a placeholder
      []
    end
  end
end
