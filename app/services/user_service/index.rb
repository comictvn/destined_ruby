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
  def register(email, password, password_confirmation)
    user = User.new(email: email, password: password, password_confirmation: password_confirmation)
    raise CustomException.new(user.errors.full_messages) unless user.valid?
    existing_user = User.find_by(email: email)
    raise CustomException.new('Email is already in use') if existing_user
    user.password = BCrypt::Password.create(password)
    user.save!
    TwilioGateway.send_confirmation_email(user.email)
    user
  end
end
# rubocop:enable Style/ClassAndModuleChildren
