class UserRegistrationService
  def register_user(name, phone_number, password)
    if User.exists?(phone_number: phone_number)
      return { status: 'failed', message: 'Phone number already registered' }
    else
      encrypted_password = BCrypt::Password.create(password)
      user = User.create(name: name, phone_number: phone_number, encrypted_password: encrypted_password)
      return { status: 'success', message: 'Registration successful', user: user }
    end
  end
end
