# PATH: /app/services/user_service/index.rb
# rubocop:disable Style/ClassAndModuleChildren
class UserService::Index
  include Pundit::Authorization
  attr_accessor :params, :records, :query
  def initialize(params, current_user = nil)
    @params = params
    @records = Api::UsersPolicy::Scope.new(current_user, User).resolve
  end
  # ... existing methods ...
  def validate_user(email, password, password_confirmation)
    errors = []
    if email.blank? || password.blank? || password_confirmation.blank?
      errors << 'All fields are required'
    end
    if email.present? && !(email =~ URI::MailTo::EMAIL_REGEXP)
      errors << 'Invalid email format'
    end
    if password != password_confirmation
      errors << 'Password and password confirmation do not match'
    end
    if errors.empty?
      { status: 'success', message: 'Validation passed' }
    else
      { status: 'error', message: errors.join(', ') }
    end
  end
  def register(email, password, password_confirmation)
    validation_result = validate_user(email, password, password_confirmation)
    return validation_result if validation_result[:status] == 'error'
    user = User.new(email: email, password: password, password_confirmation: password_confirmation)
    raise CustomException.new(user.errors.full_messages) unless user.valid?
    existing_user = User.find_by(email: email)
    raise CustomException.new('Email is already in use') if existing_user
    user.password = BCrypt::Password.create(password)
    user.save!
    TwilioGateway.send_confirmation_email(user.email)
    { status: 'success', message: 'Registration completed. Confirmation email has been sent.', user_id: user.id }
  end
end
# rubocop:enable Style/ClassAndModuleChildren
