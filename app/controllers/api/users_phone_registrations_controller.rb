module Api
  class UsersPhoneRegistrationsController < Api::BaseController
    def create
      client = Doorkeeper::Application.find_by(uid: params[:client_id], secret: params[:client_secret])
      phone_verification_service = ::Auths::PhoneVerification.new(create_params[:phone_number])
      phone_validation_result = phone_verification_service.validate_phone_number(create_params[:phone_number])

      unless phone_validation_result[:success]
        render json: { success: false, message: phone_validation_result[:message] }, status: :bad_request
        return
      end

      raise Exceptions::AuthenticationError and return if client.blank?

      result = UserService::LoginOtp.new(create_params[:phone_number]).call

      render_response(result.success) if result.success?
    end

    def create_params
      params.require(:user).permit(:phone_number)
    end
  end
end
