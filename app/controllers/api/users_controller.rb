class Api::UsersController < ApplicationController
  before_action :authenticate_user, only: [:get_potential_matches]
  def get_potential_matches
    begin
      user = User.find(params[:id])
      preferences = user.preferences
      matches = User.get_potential_matches(preferences)
      total_matches = matches.count
      total_pages = (total_matches / 10.0).ceil
      render json: { matches: matches, total_matches: total_matches, total_pages: total_pages }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: 'User not found.' }, status: :not_found
    rescue => e
      render json: { error: 'Unexpected error occurred' }, status: :internal_server_error
    end
  end
  private
  def authenticate_user
    user = User.find_by(session_token: request.headers['Authorization'])
    render json: { error: 'Not Authorized' }, status: :unauthorized unless user
  end
end
