class HealthCheckController < ApplicationController
  def index
    begin
      base_service = BaseService.find(params[:baseServiceId])
      if base_service.health_check
        render json: { status: 200, message: "The base service is healthy." }, status: :ok
      else
        render json: { status: 500, message: "An unexpected error occurred on the server." }, status: :internal_server_error
      end
    rescue ActiveRecord::RecordNotFound
      render json: { status: 400, message: "Invalid baseServiceId." }, status: :bad_request
    end
  end
end
