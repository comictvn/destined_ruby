# PATH: /app/services/user_service/index.rb
# rubocop:disable Style/ClassAndModuleChildren
class UserService::Index
  include Pundit::Authorization
  include ActiveModel::Validations
  attr_accessor :params, :records, :query, :name, :age, :gender, :location, :interests, :preferences
  validates :name, presence: true
  validates :age, numericality: { only_integer: true, greater_than: 0 }
  validates :gender, inclusion: { in: %w[male female other] }
  validates :location, presence: true
  validates :interests, presence: true
  validates :preferences, presence: true
  def initialize(params, current_user = nil)
    @params = params
    @records = Api::UsersPolicy::Scope.new(current_user, User).resolve
  end
  def execute
    validate_user(params[:name], params[:age], params[:gender], params[:location], params[:interests], params[:preferences])
    if valid?
      user = User.create!(name: @name, age: @age, gender: @gender, location: @location, interests: @interests, preferences: @preferences)
      generate_matches(user.id)
    else
      errors.full_messages
    end
  end
  def validate_user(name, age, gender, location, interests, preferences)
    @name = name
    @age = age
    @gender = gender
    @location = location
    @interests = interests
    @preferences = preferences
    valid?
  end
  def generate_matches(user_id)
    user = User.find(user_id)
    preferences = user.preferences
    interests = user.interests
    potential_matches = User.where.not(id: user_id)
    matches = []
    potential_matches.each do |potential_match|
      compatibility_score = calculate_compatibility_score(preferences, interests, potential_match)
      match = Match.create(user_id: user_id, match_id: potential_match.id, compatibility_score: compatibility_score)
      matches << match
    end
    matches
  end
  private
  def calculate_compatibility_score(preferences, interests, potential_match)
    # Implement your matching algorithm here
    # This is just a placeholder
    score = 0
    score
  end
  # ... rest of the code ...
end
# rubocop:enable Style/ClassAndModuleChildren
