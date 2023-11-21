class Api::UsersController < ApplicationController
  # Other methods...
  def no_more_potential_matches
    begin
      user_id = params[:id]
      user = User.find(user_id)
      potential_matches = User.where(preferences: user.preferences).where.not(id: user_id)
      if potential_matches.empty?
        render json: { message: 'No more potential matches.' }, status: :ok
      else
        render json: { message: 'There are still potential matches.' }, status: :ok
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: 'User not found.' }, status: :not_found
    rescue => e
      render json: { error: 'Unexpected error occurred' }, status: :internal_server_error
    end
  end
  # Other methods...
end
