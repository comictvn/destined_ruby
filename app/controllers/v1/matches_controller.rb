class V1::MatchesController < ApplicationController
  # Other methods...
  def update_status
    begin
      user = User.find(params[:id])
      matched_user = User.find(params[:matched_user_id])
      status = params[:status]
      new_status = MatchesService.new.update_status(user, matched_user, status)
      if new_status == 'liked'
        render json: { status: 200, message: 'Match status updated successfully', match_status: new_status }, status: :ok
      elsif new_status == 'matched'
        render json: { status: 200, message: 'Congratulations! You have a new match.', match_status: new_status }, status: :ok
      else
        render json: { error: 'An unexpected error occurred on the server' }, status: :internal_server_error
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: 'User not found.' }, status: :not_found
    rescue => e
      render json: { error: 'Unexpected error occurred' }, status: :internal_server_error
    end
  end
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
