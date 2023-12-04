class Api::UsersPasswordsController < Api::BaseController
  def update_password
    user = User.find(params[:id])
    if user
      encrypted_password = user.encrypt(params[:password])
      if user.update(password: encrypted_password)
        render json: { message: 'Password updated successfully' }, status: :ok
      else
        render json: { messages: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: 'User not found' }, status: :not_found
    end
  end
end
