class V1::MatchesController < ApplicationController
  # Other methods...
  def potential_matches
    begin
      user_id = params[:id]
      preferences = params[:preferences]
      user = User.find(user_id)
      potential_matches = User.where(preferences).where.not(id: user_id)
      potential_matches = potential_matches.where.not(id: Match.where(user_id: user_id).pluck(:match_id))
      matches = potential_matches.paginate(page: params[:page], per_page: 10)
      render json: { potential_matches: matches, total_matches: matches.total_entries, total_pages: matches.total_pages }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: 'User not found.' }, status: :not_found
    rescue => e
      render json: { error: 'Unexpected error occurred' }, status: :internal_server_error
    end
  end
end
