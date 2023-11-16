class Api::MatchController < ApplicationController
  before_action :authenticate_user!
  before_action :set_match, only: [:update]
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
  def update
    begin
      validate_params
      result = UpdateMatchService.new(@match, params[:result]).call
      render json: { status: 200, match: MatchSerializer.new(result).serialized_json }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: 'This match is not found' }, status: :not_found
    rescue ActionController::ParameterMissing, ArgumentError => e
      render json: { error: e.message }, status: :bad_request
    rescue => e
      render json: { error: 'Unexpected error occurred' }, status: :internal_server_error
    end
  end
  private
  def set_match
    @match = Match.find(params[:id])
  end
  def validate_params
    raise ActionController::ParameterMissing, 'Wrong format' unless params[:id].is_a?(Integer)
    raise ArgumentError, 'Invalid result.' unless ['win', 'lose', 'draw'].include?(params[:result])
  end
  def validate_id(id)
    raise MatchValidator::ValidationError, 'Wrong format' unless id.is_a?(Integer)
  end
end
