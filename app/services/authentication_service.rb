module Exceptions
  class AuthenticationError < StandardError; end
end

class AuthenticationService
  include TokenGenerator

  # Add your new methods below this line

  def authenticate_user(username, password_hash)
    user = User.find_by(username: username)
    raise Exceptions::AuthenticationError, 'User not found' unless user

    if user.password_hash != password_hash
      raise Exceptions::AuthenticationError, 'Invalid password'
    end

    token = generate_token(user)
    user.touch(:updated_at)
    token
  rescue ActiveRecord::RecordNotFound
    raise Exceptions::AuthenticationError, 'User not found'
  rescue => e
    raise Exceptions::AuthenticationError, e.message
  end

  # Add your existing methods below this line

  # Example of existing method
  def some_existing_method
    # ...
  end
end
