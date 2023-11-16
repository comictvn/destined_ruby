class V1::MatchesController < ApplicationController
  def create
    team1 = params[:team1]
    team2 = params[:team2]
    date = params[:date]
    if team1.blank? || team2.blank? || date.blank?
      render json: { errors: 'All fields are required.' }, status: :unprocessable_entity
    else
      begin
        match = MatchService::Create.new(team1, team2, date).execute
        render json: { match: match }, status: :ok
      rescue => e
        render json: { errors: e.message }, status: :internal_server_error
      end
    end
  end
  def update
    begin
      match_params = params.require(:match).permit(:id, :result)
      validate_match_params(match_params)
      match = UpdateMatchService.new(match_params).update
      render json: { match: match }, status: :ok
    rescue MatchValidator::ValidationError => e
      render json: { error: e.message }, status: :bad_request
    rescue ActiveRecord::RecordNotUnique => e
      render json: { error: 'Match is already updated.' }, status: :conflict
    rescue => e
      render json: { error: 'Unexpected error occurred' }, status: :internal_server_error
    end
  end
  private
  def validate_match_params(match_params)
    raise MatchValidator::ValidationError, 'The match id is required.' if match_params[:id].blank?
    raise MatchValidator::ValidationError, 'The result is required.' if match_params[:result].blank?
  end
end
