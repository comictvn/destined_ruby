class Api::UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ActionController::BadRequest, with: :bad_request
  def get_potential_matches
    ActiveRecord::Base.transaction do
      params.require(:id)
      raise ActionController::BadRequest.new("Wrong format") unless params[:id].is_a? Integer
      user = User.find(params[:id])
      preferences = params[:preferences] || user.preferences
      potential_matches = User.where(preferences: preferences)
                              .where.not(id: user.id)
                              .where.not(id: Match.where(user_id: user.id).pluck(:match_id))
      if potential_matches.empty?
        render json: { message: 'No more potential matches' }, status: :ok
      else
        total_matches = potential_matches.count
        total_pages = (total_matches / 10.0).ceil
        render json: { matches: potential_matches.pluck(:id, :name, :preferences), total_matches: total_matches, total_pages: total_pages }, status: :ok
      end
    end
  end
  private
  def record_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end
  def record_invalid(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end
  def parameter_missing(exception)
    render json: { error: exception.message }, status: :bad_request
  end
  def bad_request(exception)
    render json: { error: exception.message }, status: :bad_request
  end
end
