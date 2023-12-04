# typed: ignore
module Api
  class HealthCheckController < BaseController
    def index
      app_status = true
      db_status = ActiveRecord::Base.connection.active?
      if app_status && db_status
        render json: { status: 'success', message: 'Application and Database are running smoothly.' }, status: :ok
      else
        render json: { status: 'error', message: 'There is an issue with the Application or Database.' }, status: :service_unavailable
      end
    end
  end
end
