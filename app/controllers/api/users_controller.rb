class Api::UsersController < ApplicationController
  def find_potential_matches
    begin
      params.require(:id)
      raise ActionController::BadRequest.new("Wrong format") unless params[:id].is_a? Integer
      user = User.find_by(id: params[:id])
      return render json: { error: 'User not found' }, status: :not_found unless user
      preferences = user.preferences
      potential_matches = User.where(preferences: preferences).where.not(id: user.id)
      if potential_matches.empty?
        render json: { message: 'No more potential matches' }, status: :ok
      else
        render json: { matches: potential_matches }, status: :ok
      end
    rescue ActionController::ParameterMissing => e
      render json: { error: e.message }, status: :bad_request
    rescue => e
      render json: { error: 'Something went wrong' }, status: :internal_server_error
    end
  end
end
