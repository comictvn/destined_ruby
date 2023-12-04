# PATH: /app/services/user_service/index.rb
# rubocop:disable Style/ClassAndModuleChildren
class UserService::Index
  include Pundit::Authorization
  attr_accessor :params, :records, :query
  def initialize(params = {}, current_user = nil)
    @params = params
    @records = current_user ? Api::UsersPolicy::Scope.new(current_user, User).resolve : User.all
  end
  def execute
    if @params.empty?
      { all_users: @records, total_users: @records.count }
    else
      phone_number_start_with
      firstname_start_with
      lastname_start_with
      dob_equal
      gender_equal
      interests_start_with
      location_start_with
      email_start_with
      order
      paginate
    end
  end
  def verify_reset_password_request(id)
    password_reset_request = PasswordResetRequest.find_by(id: id)
    return unless password_reset_request
    if password_reset_request.status != 'verified'
      password_reset_request.update(status: 'verified')
    end
    password_reset_request
  end
  def update_password(user_id, new_password)
    user = User.find_by(id: user_id)
    return { status: 'error', message: 'User not found' } unless user
    encrypted_password = User.encrypt(new_password)
    user.update(password: encrypted_password)
    { status: 'success', message: 'Password updated successfully' }
  end
  def register_user
    phone_number = params[:phone_number]
    user = find_by_phone(phone_number)
    if user.nil?
      password = BCrypt::Password.create(params[:password])
      user = User.create(name: params[:name], phone_number: phone_number, password: password)
      { status: 'Registration successful' }
    else
      { status: 'Phone number already registered' }
    end
  end
  def find_by_phone(phone_number)
    User.find_by(phone_number: phone_number)
  end
  # ... rest of the code
end
# rubocop:enable Style/ClassAndModuleChildren
