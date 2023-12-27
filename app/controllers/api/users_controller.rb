class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update_preferences update_profile matches generate_matches generate_potential_matches complete_profile potential_matches update_complete_profile]
  before_action :authenticate_user, only: [:matches, :update_preferences, :update_profile, :generate_matches, :generate_potential_matches, :complete_profile, :potential_matches, :update_complete_profile] # Ensure user is authenticated for these actions
  before_action :set_user, only: [:update_preferences, :update_profile, :matches, :generate_matches, :generate_potential_matches, :complete_profile, :potential_matches, :update_complete_profile]

  def index
    # ... existing index action ...
  end

  def matches
    # ... existing matches action ...
  end

  def update_preferences
    # ... existing update_preferences action ...
    # The existing code for update_preferences is more comprehensive and uses services if available.
  end

  def update_profile
    # ... existing update_profile action ...
  end

  def generate_matches
    # ... existing generate_matches action ...
  end

  def generate_potential_matches
    # ... existing generate_potential_matches action ...
  end

  def complete_profile
    # ... existing complete_profile action ...
    # The existing code for complete_profile is more comprehensive and uses services if available.
  end

  def potential_matches
    # ... existing potential_matches action ...
  end

  def update_complete_profile
    # ... existing update_complete_profile action ...
    # The existing code for update_complete_profile is more comprehensive and uses services if available.
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    render json: { error: 'User not found.' }, status: :not_found unless @user
  end

  def validate_complete_profile_params
    # Ensure that age is a positive integer
    raise ArgumentError, 'Invalid age.' unless params[:age].to_i.positive?
    
    # Ensure that gender matches the enum options
    valid_genders = User.genders.keys
    raise ArgumentError, 'Invalid gender.' unless valid_genders.include?(params[:gender])
    
    # Ensure that location is a string
    raise ArgumentError, 'Invalid location.' unless params[:location].is_a?(String)
    
    # Ensure that interests is an array of strings
    raise ArgumentError, 'Invalid interests.' unless params[:interests].is_a?(Array) && params[:interests].all? { |i| i.is_a?(String) }
    
    # Ensure that preferences is a valid JSON object
    begin
      JSON.parse(params[:preferences].to_json)
    rescue JSON::ParserError
      raise ArgumentError, 'Invalid preferences.'
    end
  end

  def preferences_params
    params.require(:preferences).permit(:age_range => [], :distance, :gender => [])
  end

  def user_answers_params
    params.require(:personality_answers).map do |answer|
      answer.permit(:question_id, :answer)
    end
  end

  # ... rest of the private methods ...
end
