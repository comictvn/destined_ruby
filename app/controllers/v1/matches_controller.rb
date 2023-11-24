class V1::MatchesController < ApplicationController
  # Other methods...
  def update_status
    begin
      match = Match.find_by_id(params[:id])
      user = User.find_by_id(params[:match_user_id])
      if user
        match.update(user_id: user.id, status: params[:status])
        render json: { status: 200, message: 'Match status updated successfully', match_user_id: user.id }, status: :ok
      else
        render json: { error: 'User not found' }, status: :not_found
      end
    rescue => e
      render json: { error: 'Unexpected error occurred' }, status: :internal_server_error
    end
  end
  # Other methods...
end
