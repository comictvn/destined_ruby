class SessionsController < ApplicationController
  # Other actions ...

  # New action to handle user authentication
  def authenticate
    username = params[:username]
    password_hash = params[:password_hash]

    # Ensure that all parameters are properly validated and sanitized before processing
    if username.blank? || password_hash.blank?
      render json: { error: 'Username and password hash are required' }, status: :bad_request
      return
    end

    # Query the "users" table to find a user with the matching "username"
    user = User.find_by(username: username)

    # If no matching user is found, return an authentication error
    unless user
      render json: { error: 'Authentication failed' }, status: :unauthorized
      return
    end

    # If a user is found, compare the provided "password_hash" with the stored "password_hash" for that user
    if user.authenticate(password_hash)
      # Generate a session token or authentication token for the user
      token = TokenGenerator.generate(user)

      # Update the "users" table with the latest "updated_at" timestamp
      user.touch

      # Return the session or authentication token to the user for accessing authenticated routes
      render json: { token: token }, status: :ok
    else
      # If the password hashes do not match, return an authentication error
      render json: { error: 'Authentication failed' }, status: :unauthorized
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # Other actions ...
end
