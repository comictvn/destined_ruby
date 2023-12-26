# PATH: /app/services/health_check_service.rb
# typed: true
class HealthCheckService < BaseService
  def initialize(*_args); end
  def check_health
    begin
      ActiveRecord::Base.connection.execute('SELECT 1')
      return { status: 'ok', message: 'Application and Database are healthy.' }
    rescue StandardError => e
      Rails.logger.error "Database connection error: #{e.message}"
      return { status: 'error', message: 'Database connection error.' }
    end
  end
end
