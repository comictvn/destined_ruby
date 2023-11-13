module Api
  class UsersPhoneRegistrationsController < Api::BaseController
    def create
      client = Doorkeeper::Application.find_by(uid: params[:client_id], secret: params[:client_secret])
      raise Exceptions::AuthenticationError and return if client.blank?

      result = UserService::LoginOtp.new(create_params[:phone_number]).call

      render_response(result.success) if result.success?
    end

    def create_params
      params.require(:user).permit(:phone_number)
    end
  end
end
