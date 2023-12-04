require 'phonelib'
class UserRegistrationService
  def register_user(name, phone_number, password)
    raise 'The name is required.' if name.blank?
    raise 'Invalid phone number.' unless Phonelib.valid?(phone_number)
    raise 'Password must be at least 8 characters.' if password.length < 8
    if User.exists?(phone_number: phone_number)
      return { status: 'failed', message: 'Phone number already registered' }
    else
      encrypted_password = BCrypt::Password.create(password)
      user = User.create(name: name, phone_number: phone_number, encrypted_password: encrypted_password)
      return { status: 'success', message: 'Registration successful', user: user }
    end
  end
  def register_by_phone(name, phone, password)
    raise 'The name is required.' if name.blank?
    raise 'Invalid phone number.' unless Phonelib.valid?(phone)
    raise 'Password must be at least 8 characters.' if password.length < 8
    if User.exists?(phone: phone)
      raise 'Phone number already registered'
    end
    encrypted_password = Devise::Encryptor.digest(User, password)
    user = User.new(name: name, phone: phone, encrypted_password: encrypted_password)
    if user.save
      user
    else
      raise 'Failed to create user'
    end
  end
end
