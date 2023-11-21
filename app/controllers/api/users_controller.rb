require 'net/http'
class Api::UsersController < ApplicationController
  # Other methods...
  def check_connection
    begin
      uri = URI('http://example.com')
      res = Net::HTTP.get_response(uri)
      if res.is_a?(Net::HTTPSuccess)
        current_user.update(connection_status: true)
        message = 'Internet connection is active.'
      else
        current_user.update(connection_status: false)
        TwilioGateway.new.send_sms(current_user.phone_number, 'Your internet connection is lost.')
        message = 'Internet connection is lost.'
      end
      render json: { connection_status: current_user.connection_status, message: message }, status: :ok
    rescue => e
      render json: { error: 'Unexpected error occurred' }, status: :internal_server_error
    end
  end
  # Other methods...
end
