require 'net/http'
class ApplicationController < ActionController::Base
  before_action :check_internet_connection
  private
  def check_internet_connection
    uri = URI('http://www.google.com/')
    begin
      response = Net::HTTP.get_response(uri)
      if response.code != "200"
        render json: { status: 'offline', message: 'Internet connection lost. Please check your connection.' }, status: 503
      end
    rescue
      render json: { status: 'offline', message: 'Internet connection lost. Please check your connection.' }, status: 503
    end
  end
end
