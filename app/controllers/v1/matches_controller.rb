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
end
