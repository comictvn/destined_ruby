module Api
  class UsersPhoneRegistrationsController < Api::BaseController
    before_action :validate_params, only: [:create]
    def create
      client = Doorkeeper::Application.find_by(uid: params[:client_id], secret: params[:client_secret])
      raise Exceptions::AuthenticationError and return if client.blank?
      if User.exists?(phone: create_params[:phone])
        render json: { error: 'Phone number already registered' }, status: :unprocessable_entity
      else
        password = Devise::Encryptor.digest(User, create_params[:password])
        user = User.create(name: create_params[:name], phone: create_params[:phone], encrypted_password: password)
        render json: { message: 'Registration successful', user: user }, status: :created
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
      raise Exceptions::BadRequestError, 'Name is required' if params[:user][:name].blank?
      raise Exceptions::BadRequestError, 'Phone is required' if params[:user][:phone].blank?
      raise Exceptions::BadRequestError, 'Password is required' if params[:user][:password].blank?
    end
  end
end
