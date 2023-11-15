class Api::UsersRegistrationsController < ApplicationController
  before_action :authenticate_user!, only: [:register]
  def create
    user_params = params.permit(:email, :password, :password_confirmation)
    validator = UserValidator.new(user_params)
    unless validator.valid?
      render json: { error: validator.errors.full_messages }, status: :unprocessable_entity
      return
    end
    if User.exists?(email: user_params[:email])
      render json: { error: 'Email is already registered' }, status: :unprocessable_entity
      return
    end
    unless user_params[:password] == user_params[:password_confirmation]
      render json: { error: 'Password and password confirmation do not match' }, status: :unprocessable_entity
      return
    end
    user = UserRegistrationService.new(user_params).call
    if user.persisted?
      UserMailer.with(user: user).confirmation_email.deliver_later
      render json: { id: user.id, email: user.email, status: 'unconfirmed' }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  def register
    user_params = params.permit(:name, :status)
    if user_params[:name].length > 200
      render json: { error: 'You cannot input more 200 characters.' }, status: :bad_request
      return
    end
    unless User.statuses.include?(user_params[:status])
      render json: { error: 'Invalid status.' }, status: :bad_request
      return
    end
    user = UserRegistrationService.new(user_params).call
    if user.persisted?
      render json: { status: 200, user: { id: user.id, name: user.name, status: user.status, created_at: user.created_at, updated_at: user.updated_at } }, status: :ok
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
