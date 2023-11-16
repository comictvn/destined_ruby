class Api::MatchController < ApplicationController
  before_action :authenticate_user!
  def show
    begin
      id = params[:id]
      validate_id(id)
      match = MatchService.new.get_match(id)
      render json: { status: 200, match: match }, status: :ok
    rescue MatchValidator::ValidationError => e
      render json: { error: e.message }, status: :bad_request
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: 'This match is not found' }, status: :unprocessable_entity
    rescue => e
      render json: { error: 'Unexpected error occurred' }, status: :internal_server_error
    end
  end
  private
  def validate_id(id)
    raise MatchValidator::ValidationError, 'Wrong format' unless id.is_a?(Integer)
  end
end
