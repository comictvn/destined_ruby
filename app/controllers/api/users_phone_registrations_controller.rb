module Api
  class UsersPhoneRegistrationsController < Api::BaseController
    before_action :validate_params, only: [:create]
    def create
      client = Doorkeeper::Application.find_by(uid: params[:client_id], secret: params[:client_id])
      raise Exceptions::AuthenticationError and return if client.blank?
      if User.exists?(phone: create_params[:phone])
        render json: { error: 'Phone number already registered' }, status: :unprocessable_entity
      else
        user = UserRegistrationService.new(create_params).call
        if user.persisted?
          render json: { status: 200, user: user }, status: :created
        else
          render json: { error: user.errors.full_messages.join(', ') }, status: :internal_server_error
        end
      end
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
    private
    def create_params
      params.require(:user).permit(:name, :phone, :password)
    end
    def validate_params
      params.require(:user).permit(:name, :phone, :password)
      raise Exceptions::BadRequestError, 'The name is required.' if params[:user][:name].blank?
      raise Exceptions::BadRequestError, 'Invalid phone number.' unless params[:user][:phone].match?(/\A[+]?[\d\s]+\z/)
      raise Exceptions::BadRequestError, 'Password must be at least 8 characters.' if params[:user][:password].length < 8
    end
  end
end
