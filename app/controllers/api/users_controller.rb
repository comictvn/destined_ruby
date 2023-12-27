class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update_preferences update_profile matches generate_matches generate_potential_matches complete_profile potential_matches]
  before_action :authenticate_user, only: [:matches, :update_preferences, :update_profile, :generate_matches, :generate_potential_matches, :complete_profile, :potential_matches] # Ensure user is authenticated for these actions
  before_action :set_user, only: [:update_preferences, :update_profile, :matches, :generate_matches, :generate_potential_matches, :complete_profile, :potential_matches]

  def index
    # ... existing index action ...
  end

  def matches
    # ... existing matches action ...
  end

  def update_preferences
    # ... existing update_preferences action ...
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
    User.transaction do
      set_user
      @user.update!(age: params[:age], gender: params[:gender], location: params[:location])
      preferences = Preference.find_or_initialize_by(user_id: @user.id)
      preferences.update!(preference_data: params[:preferences].merge(interests: params[:interests]))
      user_answers_params.each do |answer_params|
        UserAnswer.find_or_initialize_by(user_id: @user.id, question_id: answer_params[:question_id])
                   .update!(answer: answer_params[:answer])
      end
      @user.touch
      preferences.touch
    end
    render json: { status: 200, message: 'Profile updated successfully.', user: @user.as_json(include: [:preferences]) }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages.to_sentence }, status: :unprocessable_entity
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def potential_matches
    begin
      # Ensure user is loaded and exists
      raise ActiveRecord::RecordNotFound unless @user.present?

      # Instantiate the MatchService and generate potential matches
      match_service = MatchService.new(@user.id)
      potential_matches = match_service.generate_potential_matches

      # Format the matches for the response
      formatted_matches = potential_matches.map do |match|
        {
          id: match[:user].id,
          age: match[:user].age,
          gender: match[:user].gender,
          location: match[:user].location,
          compatibility_score: match[:score]
        }
      end

      # Render the successful response
      render json: { status: 200, matches: formatted_matches }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found.' }, status: :not_found
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    render json: { error: 'User not found.' }, status: :not_found unless @user
  end

  def user_profile_params
    params.require(:user).permit(:age, :gender, :location, interests: [], preferences: {})
  end

  def validate_user_profile_params
    # ... existing validation logic ...
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
